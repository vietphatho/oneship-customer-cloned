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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          label != null ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            shape: CircleBorder(),
            activeColor: AppColors.secondary,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        if (label != null) ...[
          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
          Expanded(child: PrimaryText(label, style: AppTextStyles.bodyMedium)),
        ],
      ],
    );
  }
}
