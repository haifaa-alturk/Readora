import '../../domain/entities/interest_entity.dart';

class InterestModel extends InterestEntity {
  const InterestModel({
    required super.id,
    required super.name,
    required super.isSelected,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      isSelected: json['is_selected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_selected': isSelected,
    };
  }
}