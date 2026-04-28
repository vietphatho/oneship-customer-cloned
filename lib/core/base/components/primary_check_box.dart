import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';

class PrimaryCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final OutlinedBorder? shape;
  final Color? activeColor;

  const PrimaryCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.shape,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      activeColor: activeColor ?? AppColors.primary,
    );
  }
}
