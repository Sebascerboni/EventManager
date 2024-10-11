import 'package:flutter/cupertino.dart';
import 'package:forms_project/models/client/client_action_request.dart';
import 'package:forms_project/models/client/client_model.dart';

abstract class IClientViewModel extends ChangeNotifier {
  bool get isLoading;
  Future<void> fetchClient(String dni);
  ClientModel? get client;
  Future<void> createClient(ClientModelRequest client);
  Future<void> updateClient( ClientModelRequest client);
}
