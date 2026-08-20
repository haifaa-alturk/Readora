import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../../quotes/presentation/bloc/quotes_bloc.dart';
import '../../../quotes/presentation/bloc/quotes_event.dart';
import '../../../quotes/presentation/bloc/quotes_state.dart';
import '../../../quotes/domain/entities/quote_entity.dart';

class BookPreviewPage extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;
  final int bookId;
  final bool hasFullAccess;

  const BookPreviewPage({
    super.key,
    required this.pdfUrl,
    required this.bookTitle,
    required this.bookId,
    this.hasFullAccess = false,
  });

  @override
  State<BookPreviewPage> createState() => _BookPreviewPageState();
}

class _BookPreviewPageState extends State<BookPreviewPage> {
  late final PdfViewerController _controller;

  String _selectedText = '';
  bool _isSavingQuote = false;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  // ============================================================
  // PAGE CHANGE
  // ============================================================

  void _handlePageChanged(int? pageNumber) {
    if (pageNumber == null) return;
    if (_isLeaving) return;

    // إذا عنده وصول كامل، يستطيع قراءة جميع الصفحات
    if (widget.hasFullAccess) return;

    // Preview = أول 5 صفحات فقط
    if (pageNumber > 5) {
      _isLeaving = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Free preview is limited to the first 5 pages.'),
            backgroundColor: Colors.orange,
          ),
        );

        Navigator.of(context).pop();
      });
    }
  }

  // ============================================================
  // GET SELECTED TEXT
  // ============================================================

  Future<void> _updateSelectedText(PdfTextSelection selection) async {
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
          content: Text('Quote saved successfully 📑'),
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
  // SHOW SAVED QUOTES
  // ============================================================

  void _showSavedQuotes() {
    final bloc = context.read<QuotesBloc>();
    final state = bloc.state;

    if (state is QuotesLoaded) {
      _openQuotesSheet(state.quotes);
      return;
    }

    if (state is QuoteAddSuccess) {
      _openQuotesSheet(state.quotes);
      return;
    }

    if (state is QuoteDeleteSuccess) {
      _openQuotesSheet(state.quotes);
      return;
    }

    bloc.add(const LoadQuotesEvent());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 245, 242, 196),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) {
        return BlocBuilder<QuotesBloc, QuotesState>(
          builder: (context, state) {
            if (state is QuotesLoading || state is QuotesInitial) {
              return const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is QuotesError) {
              return SizedBox(
                height: 250,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(state.message, textAlign: TextAlign.center),
                  ),
                ),
              );
            }

            if (state is QuotesLoaded) {
              return _quotesSheetContent(sheetContext, state.quotes);
            }

            if (state is QuoteAddSuccess) {
              return _quotesSheetContent(sheetContext, state.quotes);
            }

            if (state is QuoteDeleteSuccess) {
              return _quotesSheetContent(sheetContext, state.quotes);
            }

            return const SizedBox(height: 250);
          },
        );
      },
    );
  }

  // ============================================================
  // OPEN QUOTES
  // ============================================================

  void _openQuotesSheet(List<QuoteEntity> quotes) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 245, 242, 196),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) {
        return _quotesSheetContent(sheetContext, quotes);
      },
    );
  }

  // ============================================================
  // QUOTES SHEET CONTENT
  // ============================================================

  Widget _quotesSheetContent(
    BuildContext sheetContext,
    List<QuoteEntity> quotes,
  ) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(sheetContext).size.height * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.format_quote,
                    color: Color.fromARGB(255, 129, 76, 7),
                    size: 30,
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      'Saved Quotes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              if (quotes.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.format_quote, size: 55, color: Colors.grey),

                        SizedBox(height: 10),

                        Text(
                          'No saved quotes yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: quotes.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final quote = quotes[index];

                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.format_quote, color: Colors.amber),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                quote.quoteText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),

                            IconButton(
                              tooltip: 'Delete quote',
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context.read<QuotesBloc>().add(
                                  DeleteQuoteEvent(quoteId: quote.id),
                                );

                                Navigator.pop(sheetContext);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(217, 240, 237, 205),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 242, 196),
        foregroundColor: Colors.black,
        centerTitle: true,

        title: Column(
          children: [
            Text(
              widget.bookTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 2),

            Text(
              widget.hasFullAccess
                  ? 'Full Book'
                  : 'Free Preview - First 5 Pages',
              style: TextStyle(
                fontSize: 11,
                color: widget.hasFullAccess ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: 'Saved Quotes',
            onPressed: _showSavedQuotes,
            icon: const Icon(Icons.format_quote, size: 28),
          ),
        ],
      ),

      body: Stack(
        children: [
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
                onTextSelectionChange: _updateSelectedText,
              ),

              onPageChanged: _handlePageChanged,

              maxScale: 5.0,
            ),
          ),

          Positioned(
            top: 15,
            left: 20,
            right: 20,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.hasFullAccess ? Icons.lock_open : Icons.menu_book,
                      color: widget.hasFullAccess
                          ? Colors.greenAccent
                          : Colors.amber,
                    ),

                    const SizedBox(width: 8),

                    Flexible(
                      child: Text(
                        widget.hasFullAccess
                            ? 'Full Book - You can read all pages'
                            : 'Free Preview - First 5 Pages',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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

          Positioned(
            right: 15,
            bottom: 25,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'preview_zoom_in',
                  backgroundColor: const Color.fromARGB(255, 245, 242, 196),
                  foregroundColor: const Color.fromARGB(255, 129, 76, 7),
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),

                const SizedBox(height: 8),

                FloatingActionButton.small(
                  heroTag: 'preview_zoom_reset',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  onPressed: _resetZoom,
                  child: const Icon(Icons.fit_screen),
                ),

                const SizedBox(height: 8),

                FloatingActionButton.small(
                  heroTag: 'preview_zoom_out',
                  backgroundColor: const Color.fromARGB(255, 245, 242, 196),
                  foregroundColor: const Color.fromARGB(255, 129, 76, 7),
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),

          if (_selectedText.isNotEmpty)
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 129, 76, 7),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(blurRadius: 10, color: Colors.black26),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.format_quote, color: Colors.amber),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Text(
                          'Text selected',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: _isSavingQuote ? null : _saveQuote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                        icon: _isSavingQuote
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Icon(Icons.bookmark_add),
                        label: Text(
                          _isSavingQuote ? 'Saving...' : 'Save Quote',
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
