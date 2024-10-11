class InvoicePaymentModel {
  String? namePayment;
  double amountPayment;

  InvoicePaymentModel({
    required this.namePayment,
    required this.amountPayment,
  });

  Map<String, dynamic> toJson() => {
    'NamePayment': namePayment,
    'AmountPayment': amountPayment,
  };
}
