import 'package:forms_project/models/login/create_user_model.dart';

import '../../models/login/login_model.dart';

abstract class ILoginService {
  Future<LoginResponseModel> login(String email, String password);
  Future<void> createUser(CreateUserModel createUserModel);
  Future<void> updateUser(CreateUserModel createUserModel);
  Future<List<CreateUserModel>> fetchUsers();
}