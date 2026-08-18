class AuthorModel {
  final int id;
  final String authorName;

  AuthorModel({required this.id, required this.authorName});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] ?? 0,
      authorName: json['author_name'] ?? '',
    );
  }
}