import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';

class PrimaryCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const PrimaryCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      shape: CircleBorder(),
      activeColor: AppColors.savingsBlue,
    );
  }
}
