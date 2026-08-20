import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../quotes/presentation/bloc/quotes_bloc.dart';
import '../../../quotes/presentation/bloc/quotes_event.dart';

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

      if (fitScale == null) {
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
  // GET SELECTED TEXT
  // ============================================================

  Future<void> _onTextSelectionChanged(PdfTextSelection selection) async {
    try {
      final text = await selection.getSelectedText();

      if (!mounted) return;

      setState(() {
        _selectedText = text.trim();
      });
    } catch (e) {
      debugPrint('Text selection error: $e');
    }
  }

  // ============================================================
  // SAVE QUOTE
  // ============================================================

  Future<void> _saveQuote() async {
    final text = _selectedText.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select some text first')),
      );

      return;
    }

    if (_isSavingQuote) {
      return;
    }

    setState(() {
      _isSavingQuote = true;
    });

    try {
      context.read<QuotesBloc>().add(
        AddQuoteEvent(bookId: widget.bookId, quoteText: text),
      );

      try {
        await _controller.textSelectionDelegate.clearTextSelection();
      } catch (e) {
        debugPrint('Clear selection error: $e');
      }

      if (!mounted) return;

      setState(() {
        _selectedText = '';
        _isSavingQuote = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quote saved successfully! 📌'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSavingQuote = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save quote: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(217, 240, 237, 205),

      // ========================================================
      // APP BAR
      // ========================================================
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

      // ========================================================
      // BODY
      // ========================================================
      body: Stack(
        children: [
          // ====================================================
          // PDF
          // ====================================================
          PdfViewer.uri(
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

          // ====================================================
          // READING INFO
          // ====================================================
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
                        'Full Book • You own this book',
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

          // ====================================================
          // SAVE QUOTE
          // ====================================================
          if (_selectedText.isNotEmpty)
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(blurRadius: 12, color: Colors.black26),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _selectedText,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
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
                            padding: const EdgeInsets.symmetric(vertical: 13),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
