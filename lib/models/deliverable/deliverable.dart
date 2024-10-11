class DeliverableModel {
  int id;
  String ticketNumber;
  int deliveryTicketid;

  DeliverableModel({
    required this.id,
    required this.ticketNumber,
    required this.deliveryTicketid
  });

  factory DeliverableModel.fromJson(Map<String, dynamic> json) {
    return DeliverableModel(
      id: json['id'],
      ticketNumber: json['ticketNumber'],
      deliveryTicketid: json['deliveryTicketid']
    );
  }
}
