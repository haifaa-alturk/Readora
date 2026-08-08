class InterestEntity {
  final int id;
  final String name;
  final bool isSelected;

  const InterestEntity({
    required this.id,
    required this.name,
    required this.isSelected,
  });

  InterestEntity copyWith({bool? isSelected}) {
    return InterestEntity(
      id: id,
      name: name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}