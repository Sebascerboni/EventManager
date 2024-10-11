import 'dart:convert';
import 'package:forms_project/models/deliverable/deliverable.dart';
import 'package:forms_project/models/deliverable/deriverable_kit.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/invoice/invoice_model.dart';
import 'iinvoice_service.dart';
import 'package:forms_project/services/configuration_api.dart';

class InvoiceService implements IInvoiceService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();
  @override
  Future<List<DeliverableModel>> createInvoice(InvoiceModel invoice) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    String errorMessage = '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/Invoice/invoice'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(invoice.toJson()),
    );
    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to create invoice';
      throw errorMessage;
    } 
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => DeliverableModel.fromJson(item)).toList();
  }

  @override
  Future<List<DeliverableKitModel>> createInvoiceKit(InvoiceModel invoice) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    String errorMessage = '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/Invoice/invoice'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(invoice.toJson()),
    );
    if (response.statusCode != 200) {

      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to create invoice';
      throw errorMessage;
    }

    List<dynamic> jsonResponse = jsonDecode(response.body);
    if(jsonResponse.isEmpty){
      return [DeliverableKitModel(id: 0, quantity: 0, msDeliveryKitId: 0, deliveryId: 0)];
    }else{
      return jsonResponse.map((item) => DeliverableKitModel.fromJson(item)).toList();
    }
  }
}
