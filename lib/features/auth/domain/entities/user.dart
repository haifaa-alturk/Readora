class User {
  final String token;
  final int id;
  final String name;
  final String email;
  final String? userImage; // أضفنا الصورة (nullable لأنها قد لا توجد)
  final List<dynamic>? interests; // أضفنا الاهتمامات

  User({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    this.userImage,
    this.interests,
  });
}