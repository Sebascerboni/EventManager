import 'package:forms_project/models/client/client_action_request.dart';
import 'package:forms_project/models/client/client_model.dart';
import 'package:forms_project/services/client/iclient_service.dart';
import 'package:forms_project/viewmodel/client/iclient_viewmodel.dart';

class ClientViewModel extends IClientViewModel {
  final IClientService _clientService;

  ClientViewModel(this._clientService);

  ClientModel? _client;

  bool _isLoading = false;

  @override
  ClientModel? get client => _client;

  @override
  bool get isLoading => _isLoading;

  @override
  Future<void> fetchClient(String dni) async {
    _isLoading = true;
    try {
      _client = await _clientService.fetchClientByDni(dni);
      notifyListeners();
    } on Exception {
      rethrow;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> createClient(ClientModelRequest client) async {
    _isLoading = true;
    try {
      await _clientService.createClient(client);
      notifyListeners();
    } on Exception {
      rethrow;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> updateClient(ClientModelRequest client) async {
    _isLoading =  true;
    try {
      await _clientService.updateClient(client);
      notifyListeners();
    } on Exception{
      rethrow;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}