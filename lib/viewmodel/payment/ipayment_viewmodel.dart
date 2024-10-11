import 'package:flutter/material.dart';


abstract class IPaymentTypeViewModel with ChangeNotifier {
  Future<void> loadPaymentTypes();
  List<String> get paymentTypeName;
}
