import '../../models/commerce/commerce_model.dart';

abstract class ICommerceService {
  Future<List<CommerceModel>> getCommerces(int eventName);
}