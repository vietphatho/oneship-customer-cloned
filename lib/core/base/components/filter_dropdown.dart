import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';

/// A compact labeled dropdown used in filter panels.
///
/// Features:
/// - Fixed height of 36px for consistent filter UI
/// - Small square border radius
/// - Generic type support
/// - Customizable item label builder
class FilterDropdown<T> extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final String hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryText(
          label,
          size: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral3,
        ),
        const SizedBox(height: 3),
        DropdownButtonFormField<T>(
          initialValue: value,
          isDense: true,
          isExpanded: true,
          style: const TextStyle(fontSize: 14, color: AppColors.neutral2),
          hint: PrimaryText(
            hintText,
            size: 14,
            color: AppColors.grey400,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: AppColors.neutral5,
          ),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: 10,
            ),
            border: _border,
            enabledBorder: _border,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondary),
              borderRadius: AppDimensions.xSmallBorderRadius,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: PrimaryText(
                itemLabel(item),
                overflow: TextOverflow.ellipsis,
                size: 14,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

const _border = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.neutral7),
  borderRadius: AppDimensions.xSmallBorderRadius,
);
