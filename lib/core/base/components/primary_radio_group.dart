import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class PrimaryRadioGroup<T> extends StatelessWidget {
  final String? title;
  final bool isRequired;
  final List<T> options;
  final T? value;

  final String Function(T value) displayLabel;
  final void Function(T value) onChanged;
  final String? Function(T value)? subTitle;
  final Axis direction;
  final EdgeInsets? padding;

  const PrimaryRadioGroup({
    super.key,
    this.title,
    required this.options,
    required this.value,
    required this.displayLabel,
    required this.onChanged,
    this.subTitle,
    this.direction = Axis.vertical,
    this.padding,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final children =
        options.map((option) {
          final label = displayLabel(option);
          final subtitleText = subTitle?.call(option);
          return RadioListTile<T>(
            value: option,
            groupValue: value,
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
            title: PrimaryText(
              label,
              style:
                  value == option
                      ? AppTextStyles.titleMedium
                      : AppTextStyles.bodyMedium,
            ),
            subtitle:
                subtitleText != null
                    ? PrimaryText(
                      subtitleText,
                      style: AppTextStyles.bodySmall,
                      color: AppColors.neutral4,
                    )
                    : null,
            contentPadding: EdgeInsets.zero,
          );
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            children: [
              PrimaryText(
                title,
                style: AppTextStyles.titleSmall,
                color: AppColors.neutral3,
              ),
              if (isRequired)
                PrimaryText(
                  " *",
                  style: AppTextStyles.titleSmall,
                  color: AppColors.expenseRed,
                ),
            ],
          ),
        ],
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child:
              direction == Axis.vertical
                  ? Column(children: children)
                  : Row(
                    children: children.map((e) => Expanded(child: e)).toList(),
                  ),
        ),
      ],
    );
  }
}
