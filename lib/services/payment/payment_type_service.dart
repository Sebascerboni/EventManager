import 'dart:convert';
import 'package:forms_project/services/payment/ipayment_type_service.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:forms_project/services/configuration_api.dart';

import '../../models/payment/payment_type_model.dart';

class PaymentTypeService implements IPaymentTypeService {

  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  @override
  Future<List<PaymentTypeModel>> getPaymentTypes() async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/api/Invoice/payment/type'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PaymentTypeModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load payment types');
    }
  }
}
