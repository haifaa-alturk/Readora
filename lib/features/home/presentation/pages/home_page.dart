import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/core/language/app_localizations.dart';

import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_state.dart';

import 'package:library_app1/features/home/presentation/widgets/all_books_grid.dart';
import 'package:library_app1/features/home/presentation/widgets/home_header.dart';
import 'package:library_app1/features/home/presentation/widgets/recommended_books_list.dart';
import 'package:library_app1/features/home/presentation/widgets/top_rated_books_list.dart';

import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;

    final lang = settingsState is SettingsLoaded
        ? settingsState.language
        : 'en';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // ======================================================
          // LOADING
          // ======================================================

          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ======================================================
          // LOADED
          // ======================================================

          if (state is HomeLoaded) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const HomeHeader(points: 250),

                  // ==================================================
                  // SUGGESTED BOOKS
                  // ==================================================
                  Padding(
                    padding: const EdgeInsets.all(16.0),

                    child: Text(
                      context.tr('suggested_books', lang),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 143, 76, 225),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  RecommendedBooksList(books: state.recommendedBooks),

                  // ==================================================
                  // TOP RATED BOOKS
                  // ==================================================
                  Padding(
                    padding: const EdgeInsets.all(16.0),

                    child: Text(
                      context.tr('top_rated_books', lang),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 143, 76, 225),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  TopRatedBooksList(books: state.topRatedBooks),

                  // ==================================================
                  // NEW BOOKS
                  // ==================================================
                  Padding(
                    padding: const EdgeInsets.all(16.0),

                    child: Text(
                      context.tr('new_books', lang),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 143, 76, 225),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  AllBooksGrid(books: state.newBooks),
                ],
              ),
            );
          }

          // ======================================================
          // ERROR
          // ======================================================

          if (state is HomeError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          // ======================================================
          // INITIAL
          // ======================================================

          return Center(child: Text(context.tr('tap_to_load', lang)));
        },
      ),
    );
  }
}
