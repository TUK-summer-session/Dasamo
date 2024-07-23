class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['tagId'] ?? 0, // null 체크를 하고 기본값을 설정합니다.
      name: json['name'] ?? '',
    );
  }
}
