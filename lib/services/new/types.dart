// import 'package:dio/dio.dart';
//
// class Api {
//   late Response response;
// }
//
// class ApiResponse {
//   late int statusCode;
//   late dynamic  response;
//   late dynamic  error;
// }
// class Token {
//   final String token ;
//   const Token({required this.token});
//   factory Token.fromJson(Map<String, dynamic> json) {
//     return Token(
//         token: json['token']
//     );
//   }
// }
//
//
// class APIError {
//   final String timestamp;
//   final int status;
//   final String error;
//   final String message;
//   final String path;
//
//
//   APIError({
//     required this.timestamp,
//     required this.status,
//     required this.error,
//     required this.message,
//     required this.path,
//   });
//
//   factory APIError.fromJson(Map<String, dynamic> json) {
//     return APIError(
//       timestamp: json['timestamp'],
//       status: json['status'],
//       error: json['error'],
//       message: json['message'],
//       path: json['path'],
//     );
//   }
// }
//
// class KeyValuePair {
//   final dynamic key;
//   final dynamic value;
//
//   KeyValuePair(this.key, this.value);
//
//   factory KeyValuePair.fromJson(Map<String, dynamic> json) {
//     return KeyValuePair(json['key'], json['value']);
//   }
// }
