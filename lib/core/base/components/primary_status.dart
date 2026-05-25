import 'package:flutter/material.dart';
import 'package:oneship_shop/core/base/components/primary_text.dart';
import 'package:oneship_shop/core/themes/app_dimensions.dart';
import 'package:oneship_shop/core/themes/app_text_style.dart';

class PrimaryStatus extends StatelessWidget {
  const PrimaryStatus({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.xxxSmallSpacing,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: AppDimensions.mediumBorderRadius,
      ),
      child: PrimaryText(label, color: color, style: AppTextStyles.bodyMedium),
    );
  }
}
