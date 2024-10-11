import 'package:forms_project/models/ConditionsAndPolicies/event_terms_conditions.dart';
import 'package:forms_project/models/ConditionsAndPolicies/privacy_policy.dart';
import 'package:forms_project/models/ConditionsAndPolicies/terms_conditions.dart';

abstract class IConditionsPoliciesService {
  Future<EventTermsAndConditionsModel> getEventTermsAndConditions(int eventId);
  Future<PrivacyPolicyModel> getPrivacyPolicies();
  Future<TermsAndConditionsModel> getTermsAndConditions();
}