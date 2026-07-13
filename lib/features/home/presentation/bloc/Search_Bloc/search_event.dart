import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class ExecuteBookSearch extends SearchEvent {
  final String? bookName;
  final int? categoryId;
  final String? language;
  final String? authorName;
  final int? authorId;
  final int? numberOfPagesFrom;
  final int? numberOfPagesTo;
  final double? sellingPriceFrom;
  final double? sellingPriceTo;
  final double? rentalPriceFrom;
  final double? rentalPriceTo;

  const ExecuteBookSearch({
    this.bookName,
    this.categoryId,
    this.language,
    
    this.authorId,
    this.numberOfPagesFrom,
    this.numberOfPagesTo,
    this.sellingPriceFrom,
    this.sellingPriceTo,
    this.rentalPriceFrom,
    this.rentalPriceTo, this.authorName,
  });

  @override
  List<Object?> get props => [
        bookName,
        categoryId,
        language,
        authorName,
        authorId,
        numberOfPagesFrom,
        numberOfPagesTo,
        sellingPriceFrom,
        sellingPriceTo,
        rentalPriceFrom,
        rentalPriceTo,
      ];
}