// lib/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:forms_project/models/login/create_user_model.dart';
import 'package:forms_project/view/client_dni.dart';
import 'package:forms_project/viewmodel/event/ievent_viewmodel.dart';
import 'package:forms_project/viewmodel/login/ilogin_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../routes/navigation_service.dart';
import '../../services/login/ilogin_service.dart';
import '../../utils/secure_storage.dart';

class LoginViewModel extends ILoginViewModel {
  final ILoginService _loginService;
  late final NavigationService _navigationService;
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  LoginViewModel(this._loginService, this._navigationService);

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  bool get isLoading => _isLoading;

  @override
  String get errorMessage => _errorMessage;

  @override
  Future<void> login(BuildContext context, String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _loginService.login(email, password);
      String? role = await _secureStorageHelper.getValue('role');
      final eventViewModel = context.read<IEventViewModel>();
      await eventViewModel.getActiveEvents();
      late int numberEvents = eventViewModel.getActiveEventsObjects().length;
      if (role == 'Admin') {
        _navigationService.navigateToEventModules(context);
      } else if (role == 'User') {
        if (numberEvents == 1) {
          String nameEvent = eventViewModel.getActiveEventsObjects()[0].name;
          int idEvent = eventViewModel.getActiveEventsObjects()[0].id;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ClientDniScreen(nameEvent: nameEvent, eventId: idEvent, numberEvents: numberEvents)));
        }else{
          _navigationService.navigateToClientListEvent(context);
        }

      }
    } on Exception {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> createUser(CreateUserModel createUserModel) async {
    _isLoading = true;
    try {
      await _loginService.createUser(createUserModel);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> updateUser(CreateUserModel createUserModel) async {
    _isLoading = true;
    try {
      await _loginService.updateUser(createUserModel);
    } on Exception {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> fetchUsers() async {
    try {
      await _loginService.fetchUsers();
    } on Exception {
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
