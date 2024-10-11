import 'dart:convert';
import 'package:forms_project/models/points/points_model.dart';
import 'package:forms_project/services/points/ipoints_servide.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:forms_project/services/configuration_api.dart';

class PointsService implements IPointsService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();
  @override
  Future<List<PointModel>> getPoints(String? clientId, int? idEvent) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/api/client/Allpoints/event?identification=$clientId&msEventEventId=$idEvent'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PointModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load commerces');
    }
  }
}
