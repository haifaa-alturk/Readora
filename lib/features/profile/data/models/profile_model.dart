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

  // ============================================================
  // FROM JSON
  // ============================================================

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    /*
      أحياناً الـ API يرجع:

      {
        "user": {
          "id": 1,
          "name": "...",
          "points": 100,
          "wallet": 500
        }
      }

      وأحياناً يرجع بيانات المستخدم مباشرة.

      لذلك ندعم الحالتين.
    */

    final Map<String, dynamic> source;

    if (json['user'] is Map) {
      source = Map<String, dynamic>.from(json['user'] as Map);
    } else {
      source = json;
    }

    return ProfileModel(
      // ----------------------------------------------------------
      // USER ID
      // ----------------------------------------------------------
      userId: _parseInt(source['id']) ?? _parseInt(source['user_id']) ?? 0,

      // ----------------------------------------------------------
      // NAME
      // ----------------------------------------------------------
      name: source['name']?.toString() ?? '',

      // ----------------------------------------------------------
      // EMAIL
      // ----------------------------------------------------------
      email: source['email']?.toString() ?? '',

      // ----------------------------------------------------------
      // POINTS
      // ----------------------------------------------------------
      //
      // النقاط مأخوذة من الباك مباشرة.
      //
      // الأولوية:
      // points
      // total_points
      //
      // لا يوجد أي رقم وهمي.
      // ----------------------------------------------------------
      points:
          _parseInt(source['points']) ?? _parseInt(source['total_points']) ?? 0,

      // ----------------------------------------------------------
      // BOOKS COUNT
      // ----------------------------------------------------------
      booksCount:
          _parseInt(source['books_count']) ??
          _parseInt(source['booksCount']) ??
          0,

      // ----------------------------------------------------------
      // WALLET
      // ----------------------------------------------------------
      //
      // الرصيد مأخوذ من الباك مباشرة.
      //
      // الأولوية:
      // wallet
      // wallet_balance
      // balance
      //
      // لا يوجد أي رقم وهمي مثل 250.
      // ----------------------------------------------------------
      walletBalance:
          _parseDouble(source['wallet']) ??
          _parseDouble(source['wallet_balance']) ??
          _parseDouble(source['balance']) ??
          0.0,

      // ----------------------------------------------------------
      // IMAGE
      // ----------------------------------------------------------
      imagePath:
          source['user_image']?.toString() ?? source['image_path']?.toString(),
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': name,
      'email': email,

      // النقاط
      'points': points,

      // عدد الكتب
      'books_count': booksCount,

      // الرصيد الحقيقي
      'wallet': walletBalance,
      'wallet_balance': walletBalance,

      if (imagePath != null) 'user_image': imagePath,
      if (imagePath != null) 'image_path': imagePath,
    };
  }

  // ============================================================
  // INT PARSER
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  // ============================================================
  // DOUBLE PARSER
  // ============================================================

  static double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}
