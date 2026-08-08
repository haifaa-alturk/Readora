import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.userId,
    required super.name,
    required super.email,
    required super.points,
    required super.booksCount,
    required super.walletBalance,
    super.imagePath,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final source = json['user'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['user'] as Map)
        : json;

    return ProfileModel(
      userId: source['id'] as int? ?? source['user_id'] as int? ?? 0,
      name: source['name'] as String? ?? '',
      email: source['email'] as String? ?? '',
      points: int.tryParse(source['points']?.toString() ?? '') ?? 0,
      booksCount: source['books_count'] as int? ?? source['booksCount'] as int? ?? 0,
      walletBalance: (source['wallet_balance'] as num?)?.toDouble() ??
          (source['walletBalance'] as num?)?.toDouble() ??
          0.0,
      imagePath: source['user_image'] as String? ?? source['image_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'points': points,
      'books_count': booksCount,
      'wallet_balance': walletBalance,
      if (imagePath != null) 'image_path': imagePath,
    };
  }
}