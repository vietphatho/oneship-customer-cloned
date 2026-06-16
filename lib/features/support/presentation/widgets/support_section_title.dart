import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class SupportSectionTitle extends StatelessWidget {
  const SupportSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return PrimaryText(
      title,
      style: AppTextStyles.labelXSmall.copyWith(
        color: AppColors.blue950,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
