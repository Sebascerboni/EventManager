class PointModel {
  final String clientID;
  final int eventID;
  final String invoicePaymentName;
  final double pointAmount; // Cambiar Double a double

  PointModel({
    required this.clientID,
    required this.eventID,
    required this.invoicePaymentName,
    required this.pointAmount,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      clientID: json['clientDni'],
      eventID: json['msEventId'],
      invoicePaymentName: json['msInvoicePointTypeName'],
      pointAmount: json['pointAmount'].toDouble(), // Asegurarse de que sea double
    );
  }
}
