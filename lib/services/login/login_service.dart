// lib/services/login_service_impl.dart
import 'dart:convert';
import 'package:forms_project/models/login/create_user_model.dart';
import 'package:forms_project/services/login/ilogin_service.dart';
import 'package:http/http.dart' as http;

import '../../models/login/login_model.dart';
import '../../utils/secure_storage.dart';
import 'package:forms_project/services/configuration_api.dart';

class LoginService implements ILoginService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    String errorMessage = '';
    final requestBody = json.encode({
      'username': email,
      'password': password,
    });

    final requestUrl = Uri.parse('$baseUrl/api/user/login');

    final response = await http.post(
      requestUrl,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final loginResponse = LoginResponseModel.fromJson(jsonResponse);
      await _secureStorageHelper.storeValue('access_token', loginResponse.accessToken);
      await _secureStorageHelper.storeValue('role', loginResponse.role);
      return loginResponse;
    } else {
      final responseData = json.decode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to login';
      throw errorMessage;
    }
  }

  @override
  Future<void> createUser(CreateUserModel createUserModel) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    String errorMessage = '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body:jsonEncode(createUserModel) ,
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to create client';
      throw errorMessage;
    }
  }

  @override
  Future<void> updateUser(CreateUserModel createUserModel) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    String errorMessage = '';
    final response = await http.put(
      Uri.parse('$baseUrl/api/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body:jsonEncode(createUserModel) ,
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to update client';
      throw errorMessage;
    }
  }

  @override
  Future<List<CreateUserModel>> fetchUsers() async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final requestUrl = Uri.parse('$baseUrl/api/user/AllUsers');
    final response = await http.get(requestUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final userList = (jsonResponse as List)
          .map((user) => CreateUserModel.fromJson(user))
          .toList();
      return userList;
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['message']);
    }
  }


}