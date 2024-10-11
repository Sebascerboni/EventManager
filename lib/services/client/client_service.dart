import 'dart:convert';

import 'package:forms_project/models/client/client_action_request.dart';
import 'package:forms_project/models/client/client_model.dart';
import 'package:forms_project/services/client/iclient_service.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:forms_project/services/configuration_api.dart';

class ClientService implements IClientService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  @override
  Future<ClientModel?> fetchClientByDni(String dni) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http
        .get(Uri.parse('$baseUrl/api/Client/client/dni?dni=$dni'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      return ClientModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 204) {
      return null;
    }
    else {
      // throw Exception('Failed to load client - Error: ${response.statusCode}');
      return null;
    }
  }

  @override
  Future<void> createClient(ClientModelRequest client) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    String errorMessage = '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/Client/client'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body:jsonEncode(client) ,
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to create client';
      throw errorMessage;
    }
  }

  @override
  Future<void> updateClient(ClientModelRequest client) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    String errorMessage = '';
    final response = await http.put(
      Uri.parse('$baseUrl/api/Client/client'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body:jsonEncode(client) ,
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to create client';
      throw errorMessage;
    }
  }
}
