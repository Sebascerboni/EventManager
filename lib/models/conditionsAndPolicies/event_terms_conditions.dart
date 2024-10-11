class EventTermsAndConditionsModel {
  int id;
  String content;
  bool isActive;
  DateTime effectiveDate;
  DateTime createAt;
  int eventId;

  EventTermsAndConditionsModel({
    required this.id,
    required this.content,
    required this.isActive,
    required this.effectiveDate,
    required this.createAt,
    required this.eventId,
  });

  factory EventTermsAndConditionsModel.fromJson(Map<String, dynamic> json) {
    return EventTermsAndConditionsModel(
      id: json['id'],
      content: json['content'],
      isActive: json['isActive'],
      effectiveDate: DateTime.parse(json['effectiveDate']),
      createAt: DateTime.parse(json['createAt']),
      eventId: json['eventId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isActive': isActive,
      'effectiveDate': effectiveDate.toIso8601String(),
      'createAt': createAt.toIso8601String(),
      'eventId': eventId,
    };
  }
}
