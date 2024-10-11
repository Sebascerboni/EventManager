class PaymentTypeModel {
  final int id;
  final String name;

  PaymentTypeModel({
    required this.id,
    required this.name,
  });

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}