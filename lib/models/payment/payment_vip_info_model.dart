class PaymentTypeVipInfoModel {
  final int id;
  final String paymentTypeName;
  final bool vip;
  final int vipCouponAmount;

  PaymentTypeVipInfoModel({
    required this.id,
    required this.paymentTypeName,
    required this.vip,
    required this.vipCouponAmount,
  });

  factory PaymentTypeVipInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypeVipInfoModel(
      id: json['id'],
      paymentTypeName: json['paymentTypeName'],
      vip: json['vip'],
      vipCouponAmount: json['vipCouponAmount'],
    );
  }
}
