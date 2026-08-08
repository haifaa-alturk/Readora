
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_state.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_state.dart';
import 'package:library_app1/features/home/presentation/widgets/all_books_grid.dart';
import 'package:library_app1/features/home/presentation/widgets/home_header.dart';
import 'package:library_app1/features/home/presentation/widgets/home_section.dart';
import 'package:library_app1/features/home/presentation/widgets/recommended_books_list.dart';
import 'package:library_app1/features/home/presentation/widgets/top_rated_books_list.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 241, 243, 244), // لون خلفيتك الداكنة
    body: BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
         
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


      const HomeHeader(points: 250,),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Suggested Books ", style: TextStyle(color: Color.fromARGB(255, 143, 76, 225), fontSize: 20,fontWeight: FontWeight.bold)),
                ),
                RecommendedBooksList(books: state.recommendedBooks),

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(" Top Reated Books", style: TextStyle(color: Color.fromARGB(255, 143, 76, 225), fontSize: 20,fontWeight: FontWeight.bold)),
                ),
                TopRatedBooksList(books: state.topRatedBooks),

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("All Books ", style: TextStyle(color: Color.fromARGB(255, 143, 76, 225), fontSize: 20,fontWeight: FontWeight.bold)),
                ),
                AllBooksGrid(books: state.newBooks), 
              ],
            ),
          );
        } else if (state is HomeError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        }
        return const Center(child: Text("اضغط لتحميل البيانات"));
      },
    ),
  );
}
}

