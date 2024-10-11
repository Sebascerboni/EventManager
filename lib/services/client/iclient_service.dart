import 'package:forms_project/models/client/client_action_request.dart';
import 'package:forms_project/models/client/client_model.dart';

abstract class IClientService {
  Future<ClientModel?> fetchClientByDni(String dni);
  Future<void> createClient(ClientModelRequest client);
  Future<void> updateClient( ClientModelRequest client);
}
