class EventConditionsModel {
  final bool? isDinnersTripleCupon;
  final double? minAmount;
  final double? maxAmount;
  final String? deliveryType;

  EventConditionsModel({
    required this.isDinnersTripleCupon,
    required this.minAmount,
    required this.maxAmount,
    this.deliveryType,
  });

  Map<String, dynamic> toJson() => {
    'isDinnersTripleCupon': isDinnersTripleCupon,
    'minAmount': minAmount,
    'maxAmount': maxAmount,
    'deliveryType': deliveryType,
  };
}
