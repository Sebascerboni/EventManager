class ActiveEventModel {
  int id;
  String name;
  DateTime startDate;
  DateTime endDate;
  String state;
  DateTime createAt;
  DateTime updateAt;

  ActiveEventModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.state,
    required this.createAt,
    required this.updateAt,
  });

  factory ActiveEventModel.fromJson(Map<String, dynamic> json) {
    return ActiveEventModel(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      state: json['state'],
      createAt: DateTime.parse(json['createAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'state': state,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }
}
