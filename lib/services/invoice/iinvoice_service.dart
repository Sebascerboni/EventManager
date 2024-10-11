import 'package:forms_project/models/deliverable/deliverable.dart';
import 'package:forms_project/models/deliverable/deriverable_kit.dart';

import '../../models/invoice/invoice_model.dart';

abstract class IInvoiceService {
  Future<List<DeliverableModel>> createInvoice(InvoiceModel invoice);
  Future<List<DeliverableKitModel>> createInvoiceKit(InvoiceModel invoice);
}
