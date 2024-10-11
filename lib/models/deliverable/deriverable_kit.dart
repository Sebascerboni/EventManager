class DeliverableKitModel {
  int id;
  int quantity;
  int msDeliveryKitId;
  int deliveryId;

  DeliverableKitModel({
    required this.id,
    required this.quantity,
    required this.msDeliveryKitId,
    required this.deliveryId
  });

  factory DeliverableKitModel.fromJson(Map<String, dynamic> json) {
    return DeliverableKitModel(
      id: json['id'],
      quantity: json['quantity'],
      msDeliveryKitId: json['msDeliveryKitId'],
      deliveryId: json['deliveryid'],
    );
  }
}
