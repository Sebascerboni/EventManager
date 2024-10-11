import 'package:flutter/material.dart';
import 'package:forms_project/models/login/create_user_model.dart';

abstract class ILoginViewModel with ChangeNotifier {
  bool get isLoading;
  String get errorMessage;

  Future<void> login(BuildContext context, String email, String password);
  Future<void> createUser(CreateUserModel createUserModel);
  Future<void> updateUser(CreateUserModel createUserModel);
  Future<void> fetchUsers();
}