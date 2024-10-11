import 'dart:convert';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/commerce/commerce_model.dart';
import 'icommerce_service.dart';
import 'package:forms_project/services/configuration_api.dart';

class CommerceService implements ICommerceService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();
  @override
  Future<List<CommerceModel>> getCommerces(int idEvent) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/api/event/commerceAvaliblesInEvent?eventId=$idEvent'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CommerceModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load commerces');
    }
  }
}
