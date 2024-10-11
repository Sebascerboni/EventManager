class PrivacyPolicyModel {
  int id;
  String content;
  bool isActive;
  DateTime effectiveDate;
  DateTime createAt;

  PrivacyPolicyModel({
    required this.id,
    required this.content,
    required this.isActive,
    required this.effectiveDate,
    required this.createAt,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: json['id'],
      content: json['content'],
      isActive: json['isActive'],
      effectiveDate: DateTime.parse(json['effectiveDate']),
      createAt: DateTime.parse(json['createAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isActive': isActive,
      'effectiveDate': effectiveDate.toIso8601String(),
      'createAt': createAt.toIso8601String(),
    };
  }
}
