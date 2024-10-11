
import '../../models/payment/payment_type_model.dart';
import '../../services/payment/ipayment_type_service.dart';
import 'ipayment_viewmodel.dart';

class PaymentTypeViewModel extends IPaymentTypeViewModel {
  final IPaymentTypeService _paymentTypeService;
  List<String> _paymentTypeNames = [];

  PaymentTypeViewModel(this._paymentTypeService);

  List<PaymentTypeModel> _paymentTypes = [];

  @override
  Future<void> loadPaymentTypes() async {
    try {
      _paymentTypes = await _paymentTypeService.getPaymentTypes();
      _paymentTypeNames = _paymentTypes.map((e) => e.name).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load payment types');
    }
  }

  @override
  List<String> get paymentTypeName => _paymentTypeNames;

}
