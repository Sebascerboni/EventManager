import 'package:forms_project/models/invoice/invoice_conditios_model.dart';

import 'invoice_payment_model.dart';

class InvoiceModel {
  final String numberInvoice;
  final String msClientClientDni;
  final int msEventEventId;
  final int msEventCommerceid;
  final double amount;
  final DateTime dateEmission;
  final List<InvoicePaymentModel> invoicePaymentsWithNames;
  final EventConditionsModel invoiceEventConditions;

  InvoiceModel({
    required this.numberInvoice,
    required this.msClientClientDni,
    required this.msEventEventId,
    required this.amount,
    required this.dateEmission,
    required this.invoicePaymentsWithNames,
    required this.invoiceEventConditions,
    required this.msEventCommerceid
  });

  Map<String, dynamic> toJson() {
    return {
      'invoice': {
        'NumberInvoice': numberInvoice,
        'MsClientClientDni': msClientClientDni,
        'MSEventEventId': msEventEventId,
        'MSEventCommerceid' : msEventCommerceid,
        'Amount': amount,
        'DateEmission': dateEmission.toIso8601String(),
      },
      'eventConditions': invoiceEventConditions.toJson(),
      'InvoicePaymentsWithNames': invoicePaymentsWithNames.map((e) => e.toJson()).toList(),
    };
  }
}