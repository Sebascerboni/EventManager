// models/auth_response.dart

class LoginResponseModel {
  final String accessToken;
  final String role;

  LoginResponseModel({
    required this.accessToken,
    required this.role,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'],
      role: json['role'],
    );
  }
}
