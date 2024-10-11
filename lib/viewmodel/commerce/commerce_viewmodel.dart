import '../../models/commerce/commerce_model.dart';
import '../../services/commerce/icommerce_service.dart';
import 'icommerce_viewmodel.dart';

class CommerceViewModel extends ICommerceViewModel {
  final ICommerceService _commerceService;

  CommerceViewModel(this._commerceService);

  List<CommerceModel> _commerces = [];

  @override
  List<CommerceModel> get commerces => _commerces;

  @override
  Future<bool> loadCommerces(int idEvent) async {
    try {
      _commerces = await _commerceService.getCommerces(idEvent);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
