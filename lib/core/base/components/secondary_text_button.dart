import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class SecondaryTextButton extends StatelessWidget {
  const SecondaryTextButton({
    super.key,
    this.onPressed,
    required this.label,
    this.padding,
  });

  final void Function()? onPressed;
  final String label;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: onPressed,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: PrimaryText(
          label,
          style: AppTextStyles.labelLarge,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
