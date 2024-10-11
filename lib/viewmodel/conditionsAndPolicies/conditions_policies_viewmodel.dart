import 'package:forms_project/models/ConditionsAndPolicies/event_terms_conditions.dart';
import 'package:forms_project/models/ConditionsAndPolicies/privacy_policy.dart';
import 'package:forms_project/models/ConditionsAndPolicies/terms_conditions.dart';
import 'package:forms_project/services/conditionsAndPolicies/iconditions_policies_service.dart';
import 'package:forms_project/viewmodel/conditionsAndPolicies/iconditions_policies_viewmodel.dart';

class ConditionsPoliciesViewModel extends IConditionsPoliciesViewModel {
  final IConditionsPoliciesService _conditionsPoliciesViewModel;

  ConditionsPoliciesViewModel(this._conditionsPoliciesViewModel);

  String _errorMessage = '';
  EventTermsAndConditionsModel? _eventTermsAndConditions;
  PrivacyPolicyModel? _privacyPolicy;
  TermsAndConditionsModel? _termsAndConditions;

  @override
  String get errorMessage => _errorMessage;

  @override
  String? get termsAndConditionsContent => _termsAndConditions?.content;

  @override
  String? get eventTermsAndConditionsContent => _eventTermsAndConditions?.content;

  @override
  String? get privacyPolicyContent => _privacyPolicy?.content;

  @override
  Future<void> getEventTermsAndConditions(int eventId) async {
    _errorMessage = '';
    try {
      _eventTermsAndConditions = await _conditionsPoliciesViewModel.getEventTermsAndConditions(eventId);
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> getPrivacyPolicies() async {
    _errorMessage = '';
    try {
     _privacyPolicy = await _conditionsPoliciesViewModel.getPrivacyPolicies();
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> getTermsAndConditions() async {
    _errorMessage = '';
    try {
     _termsAndConditions = await _conditionsPoliciesViewModel.getTermsAndConditions();
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }


}
