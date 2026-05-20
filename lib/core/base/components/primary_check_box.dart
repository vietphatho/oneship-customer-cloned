import 'package:oneship_customer/core/base/base_import_components.dart';

class PrimaryCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final String? label;

  const PrimaryCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape: CircleBorder(),
          activeColor: AppColors.secondary,
          visualDensity: VisualDensity.compact,
        ),
        if (label != null) ...[
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(child: PrimaryText(label, style: AppTextStyles.bodyMedium)),
        ],
      ],
    );
  }
}
