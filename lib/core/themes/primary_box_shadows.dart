import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';

class PrimaryBoxShadows {
  PrimaryBoxShadows._();

  static final defaultShadow = BoxShadow(
    color: Colors.black.withOpacity(0.04),
    offset: const Offset(0, 4),
    blurRadius: 12,
  );

  static const bottomNavShadow = [
    BoxShadow(color: AppColors.neutral7, blurRadius: 12.0),
  ];
}
