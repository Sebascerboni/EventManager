class PaymentTypeVipModel {
  final int? id;
  final String paymentTypeName;
  final bool vip;
  final int vipCouponAmount;

  PaymentTypeVipModel({
    this.id,
    required this.paymentTypeName,
    required this.vip,
    required this.vipCouponAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "paymentTypeName": paymentTypeName,
      "vip": vip,
      "vipCouponAmount": vipCouponAmount,
    };
  }
}
