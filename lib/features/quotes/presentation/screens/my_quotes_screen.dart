import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quotes_bloc.dart';
import '../bloc/quotes_event.dart';
import '../bloc/quotes_state.dart';
import '../../domain/entities/quote_entity.dart';

import 'package:library_app1/core/theme_dev3/app_theme.dart';

class MyQuotesScreen extends StatefulWidget {
  const MyQuotesScreen({super.key});

  @override
  State<MyQuotesScreen> createState() => _MyQuotesScreenState();
}

class _MyQuotesScreenState extends State<MyQuotesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<QuotesBloc>().add(const LoadQuotesEvent());
    });
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _deleteQuote(int id) {
    context.read<QuotesBloc>().add(DeleteQuoteEvent(quoteId: id));
  }

  // ============================================================
  // COPY QUOTE
  // ============================================================

  Future<void> _shareQuote(QuoteEntity quote) async {
    final String shareContent =
        '"${quote.quoteText}"\n— From Book: ${quote.bookTitle}';

    await Clipboard.setData(ClipboardData(text: shareContent));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'The quote was successfully copied to the clipboard!',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(185, 203, 157, 255),
        elevation: 0,
        title: const Text(
          'My quotes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      body: BlocConsumer<QuotesBloc, QuotesState>(
        listener: (context, state) {
          // ======================================================
          // ADD SUCCESS
          // ======================================================

          if (state is QuoteAddSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'The quote was successfully saved!',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }

          // ======================================================
          // DELETE SUCCESS
          // ======================================================

          if (state is QuoteDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'The quote was successfully deleted.',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }

          // ======================================================
          // ERROR
          // ======================================================

          if (state is QuotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        builder: (context, state) {
          // ======================================================
          // LOADING
          // ======================================================

          if (state is QuotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ======================================================
          // LOADED
          // ======================================================

          if (state is QuotesLoaded) {
            return _buildQuoteList(state.quotes);
          }

          // ======================================================
          // ADD SUCCESS
          // ======================================================

          if (state is QuoteAddSuccess) {
            return _buildQuoteList(state.quotes);
          }

          // ======================================================
          // DELETE SUCCESS
          // ======================================================

          if (state is QuoteDeleteSuccess) {
            return _buildQuoteList(state.quotes);
          }

          // ======================================================
          // ERROR
          // ======================================================

          if (state is QuotesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          }

          // ======================================================
          // INITIAL
          // ======================================================

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // ============================================================
  // QUOTES LIST
  // ============================================================

  Widget _buildQuoteList(List<QuoteEntity> quotes) {
    if (quotes.isEmpty) {
      return const Center(
        child: Text(
          'No quotes have been saved yet.',
          style: TextStyle(
            color: Color.fromARGB(255, 151, 57, 144),
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        final quote = quotes[index];

        return _buildQuoteCard(quote);
      },
    );
  }

  // ============================================================
  // QUOTE CARD
  // ============================================================

  Widget _buildQuoteCard(QuoteEntity quote) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,

      color: isDark
          ? const Color.fromARGB(88, 170, 21, 183).withOpacity(0.5)
          : const Color.fromARGB(255, 248, 245, 243).withOpacity(0.3),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // BOOK
            // ==================================================
            InkWell(
              onTap: () {
                debugPrint('Book ID: ${quote.bookId}');
              },

              borderRadius: BorderRadius.circular(8),

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: AppTheme.lightPink,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 14,
                      color: AppTheme.darkPink,
                    ),

                    const SizedBox(width: 6),

                    Flexible(
                      child: Text(
                        quote.bookTitle,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkPink,
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: AppTheme.darkPink,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // QUOTE TEXT
            // ==================================================
            Text(
              '"${quote.quoteText}"',
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            const Divider(height: 1, color: AppTheme.borderLight),

            const SizedBox(height: 8),

            // ==================================================
            // DATE + ACTIONS
            // ==================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  '${quote.createdAt.day}/${quote.createdAt.month}/${quote.createdAt.year}',

                  style: const TextStyle(fontSize: 11),
                ),

                Row(
                  children: [
                    // ==========================================
                    // COPY
                    // ==========================================
                    IconButton(
                      icon: const Icon(
                        Icons.share_outlined,
                        color: Colors.blue,
                        size: 20,
                      ),

                      onPressed: () => _shareQuote(quote),

                      tooltip: 'Copy',
                    ),

                    // ==========================================
                    // DELETE
                    // ==========================================
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppTheme.errorRed,
                        size: 20,
                      ),

                      onPressed: () => _deleteQuote(quote.id),

                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
