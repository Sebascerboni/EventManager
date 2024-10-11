import 'package:forms_project/models/commerce/commerce_categories_model.dart';

import '../payment/payment_vip_info_model.dart';

class EventInfoModel {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final double maxAmount;
  final double minAmount;
  final String status;
  final String? deliveryType;
  final List<PaymentTypeVipInfoModel> paymentTypeVip;
  final List<CommerceCategory>? commerceCategories;

  EventInfoModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.maxAmount,
    required this.minAmount,
    required this.status,
    required this.paymentTypeVip,
    this.deliveryType,
    this.commerceCategories,
  });

  factory EventInfoModel.fromJson(Map<String, dynamic> json) {
    var list = json['paymentTypeVip'] as List;
    List<PaymentTypeVipInfoModel> paymentTypeVipList = list.map((i) => PaymentTypeVipInfoModel.fromJson(i)).toList();
    List<CommerceCategory> commerceCategories = (json['commerceCategories'] as List).map((i) => CommerceCategory.fromJson(i)).toList();

    return EventInfoModel(
      id: json['id'],
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      maxAmount: json['maxAmount'],
      minAmount: json['minAmount'],
      status: json['status'],
      deliveryType: json['deliveryType'],
      paymentTypeVip: paymentTypeVipList,
      commerceCategories: commerceCategories,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'startDate': startDate,
    'endDate': endDate,
    'maxAmount': maxAmount,
    'minAmount': minAmount,
    'status': status,
    'deliveryType': deliveryType,
    'paymentTypeVip': paymentTypeVip,
    'commerceCategories': commerceCategories,
  };

}
