class CommentModel {
  final int id;
  final int userId;
  final int bookId;
  final String body;
  final String userName;
  final DateTime? createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.body,
    required this.userName,
    this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['users'] ?? json['user'];

    return CommentModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      bookId: int.tryParse(json['book_id']?.toString() ?? '0') ?? 0,
      body: json['body']?.toString() ?? '',
      userName: user is Map ? user['name']?.toString() ?? 'User' : 'User',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
