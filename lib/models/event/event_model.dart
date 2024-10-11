import '../payment/payment_vip_model.dart';

class EventModel {
  final int? id;
  final String eventName;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final double maxAmount;
  final double minAmount;
  final String? deliveryType;
  final List<String> categoryNamesList;
  final List<PaymentTypeVipModel> paymentTypesVip;

  EventModel({
    this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.maxAmount,
    required this.minAmount,
    required this.categoryNamesList,
    required this.paymentTypesVip,
    this.deliveryType,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "EventId": id,
      'EventName': eventName,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
      'DeliveryType': deliveryType,
      'Status': status,
      'MaxAmount': maxAmount,
      'MinAmount': minAmount,
      'CategoryNamesList': categoryNamesList,
      'PaymentTypesVip': paymentTypesVip.map((e) => e.toJson()).toList(),
    };
  }
}