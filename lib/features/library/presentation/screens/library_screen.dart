import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/library_bloc.dart';
import '../bloc/library_event.dart';
import '../bloc/library_state.dart';
import '../../domain/entities/library_book_entity.dart';
import 'package:library_app1/features/individual_challenge/presentation/individual_challenge_entry.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const List<_FilterOption> _filters = [
    _FilterOption('All', null),
    _FilterOption('In Progress', 'in_progress'),
    _FilterOption('Completed', 'completed'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(const LoadLibraryBooksEvent());
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: const Color(0xfffcfbfa),
            appBar: AppBar(
              backgroundColor: const Color(0xfffcfbfa),
              elevation: 0,
              title: const Text(
                'My Books',
                style: TextStyle(
                  color: Color(0xff2d2d2d),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is LibraryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LibraryError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Color(0xff2d2d2d)),
                    ),
                  );
                }
                if (state is LibraryEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book,
                          size: 64,
                          color: const Color(0xff2d2d2d).withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No books yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff2d2d2d),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Start reading to build your library!',
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color(0xff2d2d2d).withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is LibraryLoaded) {
                  return Column(
                    children: [
                      _buildFilterRow(state.activeFilter),
                      Expanded(
                        child: state.filteredBooks.isEmpty
                            ? Center(
                                child: Text(
                                  'No ${state.activeFilter ?? ''} books',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff2d2d2d),
                                  ),
                                ),
                              )
                            : ListView(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 24),
                                children: state.filteredBooks
                                    .map((b) => _buildBookCard(b))
                                    .toList(),
                              ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
  }

  Widget _buildFilterRow(String? activeFilter) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: _filters.map((f) {
          final isActive = f.value == activeFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                context
                    .read<LibraryBloc>()
                    .add(FilterLibraryBooksEvent(statusFilter: f.value));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xffd4c5f9).withValues(alpha: 0.25)
                      : const Color(0xff2d2d2d).withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xff7c5cbf).withValues(alpha: 0.5)
                        : const Color(0xff2d2d2d).withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  f.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? const Color(0xff7c5cbf)
                        : const Color(0xff2d2d2d).withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBookCard(LibraryBookEntity book) {
    final icon = book.status == 'completed'
        ? Icons.check_circle
        : book.status == 'in_progress'
            ? Icons.autorenew
            : book.status == 'borrowed'
                ? Icons.unfold_more
                : Icons.shopping_cart;
    final iconBgColor = book.status == 'completed'
        ? const Color(0xffd4c5f9)
        : book.status == 'in_progress'
            ? const Color(0xfffce38a)
            : book.status == 'borrowed'
                ? const Color(0xff8cd7f7)
                : const Color(0xffc2e7d9);
    final typeColor = book.status == 'completed'
        ? const Color(0xff7c5cbf)
        : book.status == 'in_progress'
            ? const Color(0xffb8860b)
            : book.status == 'borrowed'
                ? const Color(0xff2d7d2d)
                : const Color(0xffc62828);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2d2d2d).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: typeColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xff2d2d2d).withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        book.status == 'in_progress'
                            ? 'In Progress'
                            : book.status == 'completed'
                                ? 'Completed'
                                : book.status == 'borrowed'
                                    ? 'Borrowed'
                                    : 'Purchased',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: typeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (book.startDate != null)
                Text(
                  _formatDate(book.startDate!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff757575),
                  ),
                ),
              if (book.completionDate != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Done ${_formatDate(book.completionDate!)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff757575),
                  ),
                ),
              ],
              // TEMPORARY entry point for dev/testing — replace with the real
              // reader's 'reached final page' event once that screen is integrated.
              if (book.status == 'completed')
                TextButton.icon(
                  onPressed: () => openIndividualChallengeFlow(
                    context,
                    bookId: book.id,
                    bookTitle: book.title,
                  ),
                  icon: const Icon(Icons.emoji_events, size: 16),
                  label: const Text(
                    'Take the Challenge',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xff7c5cbf),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterOption {
  final String label;
  final String? value;

  const _FilterOption(this.label, this.value);
}