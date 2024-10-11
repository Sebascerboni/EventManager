import 'package:flutter/material.dart';
import 'package:forms_project/models/deliverable/deliverable.dart';
import 'package:forms_project/models/deliverable/deriverable_kit.dart';

import '../../models/invoice/invoice_model.dart';

abstract class IInvoiceViewModel with ChangeNotifier{
  String get errorMessage;
  bool get isLoading;

  List<DeliverableModel> get deliverables;
  List<DeliverableKitModel> get deliverableKits;
  Future<void> createInvoice(InvoiceModel invoice);
  Future<void> createInvoiceKit(InvoiceModel invoice);
}
