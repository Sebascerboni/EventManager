import 'package:flutter/cupertino.dart';

abstract class IConditionsPoliciesViewModel with ChangeNotifier {
  String get errorMessage;
  String? get eventTermsAndConditionsContent;
  String? get privacyPolicyContent;
  String? get termsAndConditionsContent;

  Future<void> getEventTermsAndConditions(int eventId);
  Future<void> getPrivacyPolicies();
  Future<void> getTermsAndConditions();
}