import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_book_details.dart';
import '../../domain/usecases/check_book_access.dart';
import '../../domain/usecases/purchase_book.dart';
import '../../domain/usecases/borrow_book.dart';

import 'book_details_event.dart';
import 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final GetBookDetails getBookDetails;
  final CheckBookAccess checkBookAccess;
  final PurchaseBook purchaseBook;
  final BorrowBook borrowBook;

  BookDetailsBloc(
    this.getBookDetails,
    this.checkBookAccess,
    this.purchaseBook,
    this.borrowBook,
  ) : super(BookDetailsInitial()) {
    // ==========================================
    // تحميل تفاصيل الكتاب + التحقق من الوصول
    // ==========================================

    on<LoadBookDetailsEvent>((event, emit) async {
      print("📚 Loading Book ID: ${event.bookId}");

      emit(BookDetailsLoading());

      final bookResult = await getBookDetails(event.bookId);

      await bookResult.fold(
        (failure) async {
          emit(BookDetailsError(failure));
        },

        (book) async {
          print("📕 PDF FILE = ${book.pdfFile}");

          final accessResult = await checkBookAccess(event.bookId);

          accessResult.fold(
            (failure) {
              emit(BookDetailsLoaded(book, false));
            },

            (hasAccess) {
              print("🔐 HAS ACCESS = $hasAccess");

              emit(BookDetailsLoaded(book, hasAccess));
            },
          );
        },
      );
    });

    // ==========================================
    // شراء الكتاب
    // ==========================================

    on<PurchaseBookEvent>((event, emit) async {
      final currentState = state;

      if (currentState is! BookDetailsLoaded) {
        return;
      }

      final book = currentState.book;

      print("🛒 Purchasing Book ID: ${event.bookId}");

      emit(BookDetailsPurchaseLoading(book));

      final result = await purchaseBook(
        bookId: event.bookId,
        discountPackage: event.discountPackage,
      );

      result.fold(
        (failure) {
          print("❌ Purchase Failed: $failure");

          emit(BookDetailsActionError(book, false, failure));
        },

        (_) {
          print("✅ Purchase Successful");

          emit(BookDetailsLoaded(book, true));
        },
      );
    });

    // ==========================================
    // استعارة الكتاب
    // ==========================================

    on<BorrowBookEvent>((event, emit) async {
      final currentState = state;

      if (currentState is! BookDetailsLoaded) {
        return;
      }

      final book = currentState.book;

      print("📚 Borrowing Book ID: ${event.bookId}");

      emit(BookDetailsBorrowLoading(book));

      final result = await borrowBook(
        bookId: event.bookId,
        discountPackage: event.discountPackage,
      );

      result.fold(
        (failure) {
          print("❌ Borrow Failed: $failure");

          emit(BookDetailsActionError(book, false, failure));
        },

        (_) {
          print("✅ Borrow Successful");

          emit(BookDetailsLoaded(book, true));
        },
      );
    });
  }
}
