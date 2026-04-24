import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_spacing.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class SecondaryButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;

  final Widget? icon;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  final bool isDisable;
  // final Widget? child;
  final double height;

  const SecondaryButton._({
    super.key,
    this.onPressed,
    required this.label,
    this.backgroundColor,
    this.isDisable = false,
    // this.child,
    this.height = AppDimensions.mediumHeightButton,
    this.borderColor,
    this.textColor,
    this.icon,
  });

  factory SecondaryButton.filled({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
  }) => SecondaryButton._(
    label: label,
    onPressed: onPressed,
    height: height,
    textColor: Colors.white,
    backgroundColor: AppColors.secondary,
  );

  factory SecondaryButton.outlined({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
  }) => SecondaryButton._(
    label: label,
    onPressed: onPressed,
    height: height,
    textColor: AppColors.secondary,
    backgroundColor: Colors.white,
    borderColor: AppColors.secondary,
  );

  factory SecondaryButton.iconFilled({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
    required Widget icon,
  }) {
    return SecondaryButton._(
      label: label,
      onPressed: onPressed,
      height: height,
      textColor: Colors.white,
      backgroundColor: AppColors.secondary,
      icon: icon,
    );
  }

  factory SecondaryButton.iconOutlined({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
    required Widget icon,
  }) {
    return SecondaryButton._(
      label: label,
      onPressed: onPressed,
      height: height,
      textColor: AppColors.secondary,
      backgroundColor: Colors.white,
      borderColor: AppColors.secondary,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = AppTheme.isDarkMode(context);
    // var colorScheme = AppTheme.getColorScheme(context);

    return PrimaryAnimatedPressableWidget(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (isDisable) return;
        onPressed?.call();
      },
      child: Container(
        height: height,
        padding: AppDimensions.xSmallPaddingHorizontal,
        width: AppDimensions.getSize(context).width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              onPressed == null || isDisable
                  ? AppColors.neutral8
                  : backgroundColor ?? AppColors.primary,
          borderRadius:
              height < AppDimensions.mediumHeightButton
                  ? AppDimensions.smallBorderRadius
                  : AppDimensions.largeBorderRadius,
          border:
              borderColor != null
                  ? Border.all(color: borderColor!, width: 0.8)
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              AppSpacing.horizontal(AppDimensions.smallSpacing),
            ],
            PrimaryText(
              label,
              textAlign: TextAlign.center,
              color:
                  onPressed == null || isDisable
                      ? AppColors.neutral6
                      : textColor ?? Colors.white,
              bold: true,
              style:
                  height < AppDimensions.mediumHeightButton
                      ? AppTextStyles.labelSmall
                      : AppTextStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
