import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';

class OrdersHistoryFilters {
  const OrdersHistoryFilters({
    this.province,
    this.ward,
    this.createdDate,
    this.phone = "",
    this.orderCode = "",
    this.codRange = const RangeValues(0, 1000000),
  });

  final Province? province;
  final Ward? ward;
  final DateTime? createdDate;
  final String phone;
  final String orderCode;
  final RangeValues codRange;

  factory OrdersHistoryFilters.empty() => const OrdersHistoryFilters();
}
