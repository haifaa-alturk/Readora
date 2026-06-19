// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';
// import 'package:library_app1/features/book_details/presentation/bloc/book_details_event.dart';
// import 'package:library_app1/features/book_details/presentation/bloc/book_details_state.dart';

// class BookDetailsPage extends StatefulWidget {
//   final int bookId;
//   final String title;
//   final String author;
//   final String image;
//   final String description;
//   final String? pdfFile;

//   const BookDetailsPage({
//     super.key,
//     required this.bookId,
//     required this.title,
//     required this.author,
//     required this.image,
//     required this.description,
//     required this.pdfFile,
//   });

//   @override
//   State<BookDetailsPage> createState() => _BookDetailsPageState();
// }

// class _BookDetailsPageState extends State<BookDetailsPage> {
//   @override
//   void initState() {
//     super.initState();

//     context.read<BookDetailsBloc>().add(LoadBookDetailsEvent(widget.bookId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff121212),

//       appBar: AppBar(
//         backgroundColor: const Color(0xff121212),
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),

//       body: BlocBuilder<BookDetailsBloc, BookDetailsState>(
//         builder: (context, state) {
//           if (state is BookDetailsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is BookDetailsError) {
//             return Center(
//               child: Text(
//                 state.message,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             );
//           }

//           if (state is BookDetailsLoaded) {
//             final book = state.book;

//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.network(
//                           book.coverImage,
//                           height: 300,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Icon(
//                               Icons.book,
//                               size: 120,
//                               color: Colors.white,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           book.bookName,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 10),

//                         Text(
//                           book.authors.join(", "),
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 18,
//                           ),
//                         ),

//                         const SizedBox(height: 25),

//                         const Text(
//                           "Description",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 12),

//                         Text(
//                           book.description,
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 16,
//                             height: 1.7,
//                           ),
//                         ),

//                         const SizedBox(height: 25),

//                         const Text(
//                           "Categories",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 10),

//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: book.categories
//                               .map((category) => Chip(label: Text(category)))
//                               .toList(),
//                         ),

//                         const SizedBox(height: 25),

//                         Text(
//                           "Rating: ${book.rating}",
//                           style: const TextStyle(
//                             color: Colors.amber,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 30),

//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.amber,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             onPressed: () {},
//                             child: const Text(
//                               "قراءة الكتاب",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 30),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
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

    context.read<BookDetailsBloc>().add(
      LoadBookDetailsEvent(widget.bookId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(217, 240, 237, 205),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 242, 196),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Book Details",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: BlocBuilder<BookDetailsBloc, BookDetailsState>(
        builder: (context, state) {
          if (state is BookDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is BookDetailsError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is BookDetailsLoaded) {
            final book = state.book;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "http://127.0.0.1:8000/storage/${book.coverImage}",
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return const Center(
                            child: Icon(
                              Icons.book,
                              size: 100,
                              color: Color.fromARGB(255, 215, 134, 13),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    book.bookName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold, color: Color.fromARGB(234, 129, 76, 7),

                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    book.language,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 28, 27, 27),
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.language),
                      const SizedBox(width: 5),
                      Text(book.language),

                      const SizedBox(width: 20),

                      const Icon(Icons.menu_book),
                      const SizedBox(width: 5),
                      Text("${book.pages} Pages"),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(40, 255, 255, 255),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold, color: Color.fromARGB(234, 129, 76, 7),
                         
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          book.description,
                          style: const TextStyle(
                            height: 1.5,color: Color.fromARGB(235, 9, 9, 12)
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Authors",
                          style: TextStyle(
                              color: Color.fromARGB(234, 129, 76, 7),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: book.authors
                              .map(
                                (author) => Chip(
                                  label: Text(author),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Categories",
                          style: TextStyle(
                            color: Color.fromARGB(234, 129, 76, 7),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: book.categories
                              .map(
                                (category) => Chip(
                                  label: Text(category),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Rating",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold, color: Color.fromARGB(234, 129, 76, 7),
                          
                          ),
                        ),

                        const SizedBox(height: 10),
Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              book.rating.toString(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

// Read Preview
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.amber,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () {},
    child: const Text(
      "Read Preview",
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

const SizedBox(height: 15),

// Buy & Rent
Row(
  children: [
    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Buy Action
        },
        child: const Text(
          "Buy",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Rent Action
        },
        child: const Text(
          "Rent",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 15),

// Comments Button
SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      backgroundColor: Color.fromARGB(249, 227, 228, 206),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () {
      // Open Comments
    },
    icon: const Icon(Icons.comment_outlined),
    label: const Text(
      "Comments",
      style: TextStyle(fontSize: 18,color: Color.fromARGB(253, 0, 0, 4)),
    ),
  ),
),

const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}