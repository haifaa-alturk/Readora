class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      // استخدام .toInt() أو التحويل الصريح يحمي من أخطاء الـ JSON
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
    );
  }
}