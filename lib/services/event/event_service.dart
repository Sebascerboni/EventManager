import 'dart:convert';

import 'package:forms_project/models/category/category_model.dart';
import 'package:forms_project/models/event/active_events_model.dart';
import 'package:forms_project/models/event/event_model.dart';
import 'package:forms_project/models/payment/payment_type_model.dart';
import 'package:forms_project/services/event/ievent_service.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:forms_project/services/configuration_api.dart';

import '../../models/event/event_info_model.dart';

class EventService implements IEventService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  @override
  Future<List<ActiveEventModel>> getActiveEvents() async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final requestUrl = Uri.parse('$baseUrl/api/event/activeEvents');
    final response = await http.get(requestUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final activeEventList = (jsonResponse as List)
          .map((activeEvent) => ActiveEventModel.fromJson(activeEvent))
          .toList();
      return activeEventList;
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['message']);
    }
  }

  @override
  Future<List<PaymentTypeModel>> getPaymentType() async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final requestUrl = Uri.parse('$baseUrl/api/Invoice/payment/type');
    final response = await http.get(requestUrl, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paymentTypeList = (jsonResponse as List)
          .map((name) => PaymentTypeModel.fromJson(name))
          .toList();
      return paymentTypeList;
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['message']);
    }
  }

  @override
  Future<void> createEvent(EventModel event) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    String errorMessage = '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/event'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to create event';
      throw errorMessage;
    }
  }

  @override
  Future<void> createEventKit(EventModel event) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    String errorMessage = '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/event'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to create event';
      throw errorMessage;
    }
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final requestUrl = Uri.parse('$baseUrl/api/event/allcategories');
    final response = await http.get(requestUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      // List<dynamic> body = jsonDecode(response.body);
      // return body.map((dynamic item) => CategoryModel.fromJson(item)).toList();
      final jsonResponse = json.decode(response.body);
      final categoryList = (jsonResponse as List)
          .map((categoryList) => CategoryModel.fromJson(categoryList))
          .toList();
      return categoryList;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Future<List<PaymentTypeModel>> fetchPaymentTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/api/event/allPaymentType'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => PaymentTypeModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load payment types');
    }
  }

  @override
  Future<EventInfoModel> getEventInfo(int id) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/api/event/eventInfo?eventId=$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return EventInfoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load event info');
    }
  }

  @override
  Future<List<EventInfoModel>> searchEvents(String eventName, String startDate, String endDate, String status) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final requestBody = json.encode({
      'Eventname': eventName.isEmpty ? null : eventName,
      'Startdate': startDate.isEmpty ? null : startDate,
      'endDate': endDate.isEmpty ? null : endDate ,
      'Status' : status.isEmpty ? null : status
    });
    final requestUrl = Uri.parse('$baseUrl/api/Event/EventList');
    final response = await http.post(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => EventInfoModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    String errorMessage = '';
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http.put(
      Uri.parse('$baseUrl/api/event'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? 'Failed to create client';
      throw errorMessage;
    }
  }
}