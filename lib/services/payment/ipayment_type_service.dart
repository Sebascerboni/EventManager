import '../../models/payment/payment_type_model.dart';

abstract class IPaymentTypeService {
  Future<List<PaymentTypeModel>> getPaymentTypes();
}
