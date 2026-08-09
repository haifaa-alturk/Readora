abstract class FavoriteEvent {}

class FetchFavoritesEvent extends FavoriteEvent {
  final String token;
  FetchFavoritesEvent(this.token);
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final String token;
  final int bookId;
  final bool isCurrentlyFavorite;

  ToggleFavoriteEvent({
    required this.token,
    required this.bookId,
    required this.isCurrentlyFavorite,
  });
}