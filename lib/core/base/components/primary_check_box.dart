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
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape: CircleBorder(),
          activeColor: AppColors.savingsBlue,
          visualDensity: VisualDensity.compact,
        ),
        if (label != null) ...[
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          PrimaryText(label),
        ],
      ],
    );
  }
}
