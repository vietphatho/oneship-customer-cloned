import 'package:oneship_customer/core/base/base_import_components.dart';

class PrimaryStatusBadge extends StatelessWidget {
  const PrimaryStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimensions.xSmallSpacing,
      vertical: AppDimensions.xxSmallSpacing,
    ),
    this.borderRadius = AppDimensions.smallBorderRadius,
    this.textStyle,
    this.iconSize = AppDimensions.xSmallIconSize,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final TextStyle? textStyle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withOpacity(0.12),
        borderRadius: borderRadius,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: color),
            AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
          ],
          PrimaryText(
            label,
            style: textStyle ?? AppTextStyles.labelXSmall.copyWith(fontSize: 12),
            color: color,
          ),
        ],
      ),
    );
  }
}
