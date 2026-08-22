import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../quotes/presentation/bloc/quotes_bloc.dart';
import '../../../quotes/presentation/bloc/quotes_event.dart';
import '../../../quotes/presentation/bloc/quotes_state.dart';

class BookReaderPage extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;
  final int bookId;

  const BookReaderPage({
    super.key,
    required this.pdfUrl,
    required this.bookTitle,
    required this.bookId,
  });

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  late final PdfViewerController _controller;

  String _selectedText = '';
  bool _isSavingQuote = false;

  @override
  void initState() {
    super.initState();

    _controller = PdfViewerController();
  }

  // ============================================================
  // ZOOM IN
  // ============================================================

  Future<void> _zoomIn() async {
    try {
      await _controller.zoomUp();
    } catch (e) {
      debugPrint('Zoom in error: $e');
    }
  }

  // ============================================================
  // ZOOM OUT
  // ============================================================

  Future<void> _zoomOut() async {
    try {
      await _controller.zoomDown();
    } catch (e) {
      debugPrint('Zoom out error: $e');
    }
  }

  // ============================================================
  // RESET ZOOM
  // ============================================================

  Future<void> _resetZoom() async {
    try {
      final fitScale = _controller.alternativeFitScale;

      if (fitScale == null || !mounted) {
        return;
      }

      final size = MediaQuery.of(context).size;

      await _controller.setZoom(
        Offset(size.width / 2, size.height / 2),
        fitScale,
      );
    } catch (e) {
      debugPrint('Reset zoom error: $e');
    }
  }

  // ============================================================
  // TEXT SELECTION
  // ============================================================

  Future<void> _onTextSelectionChanged(PdfTextSelection selection) async {
    try {
      final text = await selection.getSelectedText();

      if (!mounted) {
        return;
      }

      final cleanText = text.trim();

      debugPrint('======================================');
      debugPrint('SELECTED TEXT: $cleanText');
      debugPrint('======================================');

      setState(() {
        _selectedText = cleanText;
      });
    } catch (e) {
      debugPrint('Text selection error: $e');
    }
  }

  // ============================================================
  // SAVE QUOTE
  // ============================================================

  void _saveQuote() {
    final text = _selectedText.trim();

    if (text.isEmpty) {
      _showMessage('Please select some text first.', Colors.orange);
      return;
    }

    if (_isSavingQuote) {
      return;
    }

    debugPrint('======================================');
    debugPrint('SAVING QUOTE LOCALLY');
    debugPrint('BOOK ID: ${widget.bookId}');
    debugPrint('BOOK TITLE: ${widget.bookTitle}');
    debugPrint('TEXT: $text');
    debugPrint('======================================');

    setState(() {
      _isSavingQuote = true;
    });

    context.read<QuotesBloc>().add(
      AddQuoteEvent(
        bookId: widget.bookId,
        quoteText: text,
        bookTitle: widget.bookTitle,
      ),
    );
  }

  // ============================================================
  // CLEAR SELECTION
  // ============================================================

  Future<void> _clearSelection() async {
    // أولًا نمسح من واجهة Flutter
    if (mounted) {
      setState(() {
        _selectedText = '';
      });
    }

    // بعدها نحاول نمسح التحديد من PDF
    try {
      await _controller.textSelectionDelegate.clearTextSelection();
    } catch (e) {
      debugPrint('Clear selection error: $e');
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message, Color color) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuotesBloc, QuotesState>(
      listener: (context, state) async {
        // ======================================================
        // SUCCESS
        // ======================================================

        if (state is QuoteAddSuccess) {
          debugPrint('======================================');
          debugPrint('QUOTE SAVED LOCALLY SUCCESSFULLY');
          debugPrint('TOTAL QUOTES: ${state.quotes.length}');
          debugPrint('======================================');

          if (!mounted) {
            return;
          }

          // مهم جدًا:
          // نوقف Saving ونخفي لوحة الحفظ مباشرة
          setState(() {
            _isSavingQuote = false;
            _selectedText = '';
          });

          _showMessage('Quote saved successfully! 📌', Colors.green);

          // محاولة إزالة تحديد النص من PDF
          try {
            await _controller.textSelectionDelegate.clearTextSelection();
          } catch (e) {
            debugPrint('Clear PDF selection after save error: $e');
          }

          return;
        }

        // ======================================================
        // ERROR
        // ======================================================

        if (state is QuotesError) {
          debugPrint('❌ QUOTE ERROR: ${state.message}');

          if (!mounted) {
            return;
          }

          setState(() {
            _isSavingQuote = false;
          });

          _showMessage(state.message, Colors.red);

          return;
        }
      },

      child: Scaffold(
        backgroundColor: const Color.fromARGB(217, 240, 237, 205),

        // ======================================================
        // APP BAR
        // ======================================================
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 245, 242, 196),

          foregroundColor: Colors.black,

          elevation: 0,

          title: Text(
            widget.bookTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          actions: [
            IconButton(
              tooltip: 'Zoom out',
              onPressed: _zoomOut,
              icon: const Icon(Icons.text_decrease),
            ),

            IconButton(
              tooltip: 'Reset zoom',
              onPressed: _resetZoom,
              icon: const Icon(Icons.fit_screen),
            ),

            IconButton(
              tooltip: 'Zoom in',
              onPressed: _zoomIn,
              icon: const Icon(Icons.text_increase),
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================
        body: Stack(
          children: [
            // ==================================================
            // PDF
            // ==================================================
            Positioned.fill(
              child: PdfViewer.uri(
                Uri.parse(widget.pdfUrl),

                controller: _controller,

                params: PdfViewerParams(
                  margin: 10,

                  backgroundColor: const Color.fromARGB(217, 240, 237, 205),

                  textSelectionParams: PdfTextSelectionParams(
                    enabled: true,
                    enableSelectionHandles: true,
                    showContextMenuAutomatically: true,
                    onTextSelectionChange: _onTextSelectionChanged,
                  ),

                  maxScale: 5.0,
                ),
              ),
            ),

            // ==================================================
            // READING INFO
            // ==================================================
            Positioned(
              top: 12,
              left: 15,
              right: 15,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_open, color: Colors.amber, size: 19),

                      SizedBox(width: 7),

                      Flexible(
                        child: Text(
                          'Full Book • You have access',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==================================================
            // SAVE QUOTE PANEL
            // ==================================================
            if (_selectedText.isNotEmpty)
              Positioned(
                left: 15,
                right: 15,
                bottom: 15,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 15,
                          spreadRadius: 1,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ======================================
                        // SELECTED TEXT
                        // ======================================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.35),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.format_quote,
                                color: Colors.amber,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  _selectedText,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ======================================
                        // BUTTONS
                        // ======================================
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _isSavingQuote
                                    ? null
                                    : _clearSelection,

                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),

                                child: const Text('Cancel'),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: _isSavingQuote ? null : _saveQuote,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    129,
                                    76,
                                    7,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),

                                icon: _isSavingQuote
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.bookmark_add),

                                label: Text(
                                  _isSavingQuote ? 'Saving...' : 'Save Quote',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
