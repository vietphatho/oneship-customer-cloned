import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';

class FilterTextField extends StatelessWidget {
  const FilterTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral3,
          ),
        ),
        const SizedBox(height: 3),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(fontSize: 14, color: AppColors.neutral2),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.grey400),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: 10,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : SizedBox(
                    width: 28,
                    child: Center(child: prefixIcon),
                  ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 28, maxWidth: 28),
            suffixIcon: suffixIcon == null
                ? null
                : SizedBox(
                    width: 28,
                    child: Center(child: suffixIcon),
                  ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 28, maxWidth: 28),
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border.copyWith(
              borderSide: const BorderSide(color: AppColors.secondary),
            ),
            disabledBorder: _border.copyWith(
              borderSide: const BorderSide(color: AppColors.neutral8),
            ),
          ),
        ),
      ],
    );
  }
}

const _border = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.neutral7),
  borderRadius: AppDimensions.xSmallBorderRadius,
);
