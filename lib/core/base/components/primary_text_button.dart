import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class PrimaryTextButton extends StatelessWidget {
  const PrimaryTextButton({super.key, this.onPressed, required this.label});

  final void Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: PrimaryText(
        label,
        style: AppTextStyles.labelLarge,
        color: AppColors.primary,
      ),
    );
  }
}
