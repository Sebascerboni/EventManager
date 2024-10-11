class CommerceModel {
  final int id;
  final String razonSocial;
  final int ruc;
  final DateTime createAt;
  final DateTime updateAt;
  final int commerceCategoryId;

  CommerceModel({
    required this.id,
    required this.razonSocial,
    required this.ruc,
    required this.createAt,
    required this.updateAt,
    required this.commerceCategoryId,
  });

  factory CommerceModel.fromJson(Map<String, dynamic> json) {
    return CommerceModel(
      id: json['id'],
      razonSocial: json['razonSocial'],
      ruc: json['ruc'],
      createAt: DateTime.parse(json['createAt']),
      updateAt: DateTime.parse(json['updateAt']),
      commerceCategoryId: json['commerceCategoryId'],
    );
  }
}
