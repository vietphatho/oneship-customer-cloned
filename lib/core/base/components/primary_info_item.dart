import 'package:oneship_customer/core/base/base_import_components.dart';

class PrimaryInfoItemData {
  const PrimaryInfoItemData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
}

class PrimaryInfoItem extends StatelessWidget {
  const PrimaryInfoItem({
    super.key,
    required this.data,
    this.iconSize = AppDimensions.xxxLargeSpacing,
    this.labelStyle,
    this.valueStyle,
  });

  final PrimaryInfoItemData data;
  final double iconSize;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(data.icon, color: data.iconColor, size: iconSize),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        PrimaryText(
          data.label,
          style: labelStyle ?? AppTextStyles.bodySmall.copyWith(fontSize: 11),
          color: AppColors.neutral4,
          textAlign: TextAlign.center,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
        PrimaryText(
          data.value,
          style: valueStyle ?? AppTextStyles.labelXSmall.copyWith(fontSize: 12),
          textAlign: TextAlign.center,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
