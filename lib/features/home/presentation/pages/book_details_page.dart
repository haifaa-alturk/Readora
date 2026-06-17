import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_event.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_state.dart';

class BookDetailsPage extends StatefulWidget {
  final int bookId;
  final String title;
  final String author;
  final String image;
  final String description;
  final String? pdfFile;

  const BookDetailsPage({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.image,
    required this.description,
    required this.pdfFile,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  void initState() {
    super.initState();

    context.read<BookDetailsBloc>().add(LoadBookDetailsEvent(widget.bookId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),

      appBar: AppBar(
        backgroundColor: const Color(0xff121212),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: BlocBuilder<BookDetailsBloc, BookDetailsState>(
        builder: (context, state) {
          if (state is BookDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookDetailsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (state is BookDetailsLoaded) {
            final book = state.book;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          book.coverImage,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.book,
                              size: 120,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.bookName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          book.authors.join(", "),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Description",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          book.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Categories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: book.categories
                              .map((category) => Chip(label: Text(category)))
                              .toList(),
                        ),

                        const SizedBox(height: 25),

                        Text(
                          "Rating: ${book.rating}",
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "قراءة الكتاب",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
