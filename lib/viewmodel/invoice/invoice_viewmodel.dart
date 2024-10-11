import 'package:forms_project/models/deliverable/deliverable.dart';
import 'package:forms_project/models/deliverable/deriverable_kit.dart';

import '../../models/invoice/invoice_model.dart';
import '../../services/invoice/iinvoice_service.dart';
import 'iinvoice_viewmodel.dart';

class InvoiceViewModel extends IInvoiceViewModel {
  final IInvoiceService _invoiceService;
  bool _isLoading = false;
  String _errorMessage = '';
  List<DeliverableModel> _deliverables = [];
  List<DeliverableKitModel> _deliverableKits = [];
  InvoiceViewModel(this._invoiceService);

  @override
  List<DeliverableModel> get deliverables => _deliverables;

  @override
  List<DeliverableKitModel> get deliverableKits => _deliverableKits;

  @override
  String get errorMessage => _errorMessage;

  @override
  bool get isLoading => _isLoading;

  @override
  Future<void> createInvoice(InvoiceModel invoice) async {
    _errorMessage = '';
    // notifyListeners();
    _isLoading = true;
    try {
      _deliverables = await _invoiceService.createInvoice(invoice);
    } catch (e) {
      rethrow;
    } finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> createInvoiceKit(InvoiceModel invoice) async {
    _errorMessage = '';
    _isLoading = true;
    try {
      _deliverableKits = await _invoiceService.createInvoiceKit(invoice);
    } catch (e) {
      rethrow;
    } finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}
