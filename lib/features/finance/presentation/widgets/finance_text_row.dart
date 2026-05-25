import 'package:flutter/material.dart';
import 'package:oneship_shop/core/base/components/primary_text.dart';
import 'package:oneship_shop/core/themes/app_text_style.dart';

class FinanceTextRow extends StatelessWidget {
  const FinanceTextRow({
    super.key,
    required this.label,
    this.value,
    this.widget,
    this.labelStyle,
    this.valueStyle,
  });
  final String label;
  final String? value;
  final Widget? widget;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryText(label, style: labelStyle ?? AppTextStyles.bodyMedium),
        value != null
            ? PrimaryText(value, style: valueStyle ?? AppTextStyles.titleMedium)
            : Container(child: widget,),
      ],
    );
  }
}
