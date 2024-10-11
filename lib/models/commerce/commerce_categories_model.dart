class CommerceCategory {
  final int id;
  final String name;
  final DateTime? createAt;
  final DateTime? updateAt;

  CommerceCategory({
    required this.id,
    required this.name,
    this.createAt,
    this.updateAt,
  });

  factory CommerceCategory.fromJson(Map<String, dynamic> json) {
    return CommerceCategory(
      id: json['id'],
      name: json['name'],
      createAt: DateTime.parse(json['createAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }
}
