class CreateUserModel {
  final String username;
  final String? email;
  final String? password;
  final String state;
  final String? role;
  final DateTime? lastUpdate;


  CreateUserModel({
    required this.username,
    this.email,
    this.password,
    required this.state,
    this.role,
    this.lastUpdate,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) {
    return CreateUserModel(
      username: json['username'],
      email: json['email'],
      // password: json['password'],
      role: json['role'],
      state: json['state'],
      lastUpdate: DateTime.parse(json['lastUpdate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      // 'email': email,
      'password': password,
      'role': role,
      'state': state,
      'lastUpdate': lastUpdate,
    };
  }
}
