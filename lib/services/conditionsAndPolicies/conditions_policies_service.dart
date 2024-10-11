import 'dart:convert';

import 'package:forms_project/models/ConditionsAndPolicies/event_terms_conditions.dart';
import 'package:forms_project/models/ConditionsAndPolicies/privacy_policy.dart';
import 'package:forms_project/models/ConditionsAndPolicies/terms_conditions.dart';
import 'package:forms_project/services/conditionsAndPolicies/iconditions_policies_service.dart';
import 'package:forms_project/services/configuration_api.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class ConditionsPoliciesService implements IConditionsPoliciesService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  @override
  Future<EventTermsAndConditionsModel> getEventTermsAndConditions(int eventId) async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/api/Event/TermsAndConditions?eventId=$eventId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return EventTermsAndConditionsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load event terms and conditions - Error: ${response.statusCode}');
    }
  }

  @override
  Future<PrivacyPolicyModel> getPrivacyPolicies() async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/api/client/PrivacyPolicy'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return PrivacyPolicyModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load privacy policy - Error: ${response.statusCode}');
    }
  }

  @override
  Future<TermsAndConditionsModel> getTermsAndConditions() async {
    String? token = await _secureStorageHelper.getValue('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/api/client/TermsAndConditions'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return TermsAndConditionsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load terms and conditions - Error: ${response.statusCode}');
    }
  }

}