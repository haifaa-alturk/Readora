import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/library_bloc.dart';
import '../bloc/library_event.dart';
import '../bloc/library_state.dart';
import '../../domain/entities/library_book_entity.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const List<_FilterOption> _filters = [
    _FilterOption('All', null),
  ];

  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(const LoadLibraryBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: const Text(
                'My Books',
                style: TextStyle(
                 
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
                         
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No books yet',
                          style: TextStyle(
                            fontSize: 16,
                           
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Start reading to build your library!',
                          style: TextStyle(
                            fontSize: 13,
                           
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
                                  'No books',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  
                                  ),
                                ),
                              )
                            : ListView(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 24),
                                children: [
                                    ...state.filteredBooks.indexed.map(
                                      (entry) =>
                                          _buildBookCard(entry.$2, entry.$1),
                                    ),
                                  ],
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
                      : const Color.fromARGB(255, 85, 84, 84).withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xff7c5cbf).withValues(alpha: 0.5)
                        : const Color.fromARGB(255, 97, 95, 95).withValues(alpha: 0.1),
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

  static const List<_PastelColor> _pastelColors = [
    _PastelColor(Color(0xFFFFF3CD), Color(0xFFE6C87B)), // light yellow
    _PastelColor(Color(0xFFFBD9E2), Color(0xFFE89BB0)), // light pink
    _PastelColor(Color(0xFFD7F0D6), Color(0xFF9CCB9C)), // light green
    _PastelColor(Color(0xFFF0E0D6), Color(0xFFD4B39E)), // light nude
    _PastelColor(Color(0xFFD6E6F5), Color(0xFF9DBEDD)), // light blue
    _PastelColor(Color(0xFFE8E6EC), Color(0xFFB9B5C4)), // light gray
  ];

  Widget _buildBookCard(LibraryBookEntity book, int index) {
    final isRented = book.status == 'borrowed';
    final pastel = _pastelColors[index % _pastelColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pastel.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pastel.border,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: pastel.border.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: pastel.border.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.menu_book,
              color: pastel.border,
              size: 24,
            ),
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
                    
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  style: TextStyle(
                    fontSize: 13,
                    
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (book.displayDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${isRented ? 'Rented' : 'Purchased'} ${book.displayDate}',
                    style: const TextStyle(
                      fontSize: 12,
                      
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PastelColor {
  final Color background;
  final Color border;

  const _PastelColor(this.background, this.border);
}

class _FilterOption {
  final String label;
  final String? value;

  const _FilterOption(this.label, this.value);
}