import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadLibraryBooksEvent extends LibraryEvent {
  const LoadLibraryBooksEvent();
}

class FilterLibraryBooksEvent extends LibraryEvent {
  final String? statusFilter;

  const FilterLibraryBooksEvent({this.statusFilter});

  @override
  List<Object?> get props => [statusFilter];
}