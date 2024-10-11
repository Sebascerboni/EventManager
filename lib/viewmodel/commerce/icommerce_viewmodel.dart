import 'package:flutter/material.dart';

import '../../models/commerce/commerce_model.dart';

abstract class ICommerceViewModel extends ChangeNotifier{
  Future<bool> loadCommerces(int idEvent);
  List<CommerceModel> get commerces;
}