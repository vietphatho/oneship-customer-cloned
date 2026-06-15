import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

enum PrimaryActionButtonType { filled, outlined, dangerFilled, dangerOutlined }

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.type = PrimaryActionButtonType.filled,
    this.height = AppDimensions.mediumHeightButton,
    this.width,
    this.padding = AppDimensions.smallPaddingHorizontal,
    this.borderRadius = AppDimensions.mediumBorderRadius,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.disabledBackgroundColor = AppColors.neutral8,
    this.disabledTextColor = AppColors.neutral6,
    this.textStyle,
    this.isDisable = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? trailingIcon;
  final PrimaryActionButtonType type;
  final double height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color disabledBackgroundColor;
  final Color disabledTextColor;
  final TextStyle? textStyle;
  final bool isDisable;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isDisable;
    final isOutlined =
        type == PrimaryActionButtonType.outlined ||
        type == PrimaryActionButtonType.dangerOutlined;
    final baseColor =
        type == PrimaryActionButtonType.dangerFilled ||
        type == PrimaryActionButtonType.dangerOutlined
        ? AppColors.error
        : AppColors.primary;
    final resolvedBackgroundColor = isDisabled
        ? disabledBackgroundColor
        : backgroundColor ?? (isOutlined ? Colors.white : baseColor);
    final resolvedBorderColor = isDisabled
        ? disabledBackgroundColor
        : borderColor ?? (isOutlined ? baseColor : Colors.transparent);
    final resolvedTextColor = isDisabled
        ? disabledTextColor
        : textColor ?? (isOutlined ? baseColor : Colors.white);

    return PrimaryAnimatedPressableWidget(
      onTap: isDisabled || isLoading ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding: padding,
        decoration: BoxDecoration(
          color: resolvedBackgroundColor,
          borderRadius: borderRadius,
          border: Border.all(color: resolvedBorderColor),
        ),
        child: isLoading
            ? SizedBox.square(
                dimension: AppDimensions.smallIconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(resolvedTextColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: resolvedTextColor,
                        size: AppDimensions.smallIconSize,
                      ),
                      child: icon!,
                    ),
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                  ],
                  PrimaryText(
                    label,
                    style: textStyle ?? AppTextStyles.labelXSmall,
                    color: resolvedTextColor,
                  ),
                  if (trailingIcon != null) ...[
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    IconTheme(
                      data: IconThemeData(
                        color: resolvedTextColor,
                        size: AppDimensions.smallIconSize,
                      ),
                      child: trailingIcon!,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
