enum MarkerType { customer, shop }

extension MarkerTypeX on MarkerType {
  static const _mapValue = {
    MarkerType.customer: "customer",
    MarkerType.shop: "shop",
  };

  String get value => _mapValue[this]!;
}