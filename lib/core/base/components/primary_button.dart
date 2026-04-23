import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  final bool isDisable;
  final Widget? child;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.label = "",
    this.backgroundColor,
    this.isDisable = false,
    this.child,
    this.height = 56.0,
    this.borderColor,
    this.textColor,
  });

  static final double _defaultHeightButton = AppDimensions.mediumHeightButton;

  factory PrimaryButton.primary({
    required String label,
    Function()? onPressed,
    final double? height,
  }) => PrimaryButton(
    label: label,
    onPressed: onPressed,
    height: height ?? _defaultHeightButton,
    textColor: Colors.white,
  );

  factory PrimaryButton.supportingPrimary({
    required String label,
    Function()? onPressed,
    final double? height,
  }) => PrimaryButton(
    label: label,
    onPressed: onPressed,
    height: height ?? _defaultHeightButton,
    textColor: Colors.white,
    backgroundColor: AppColors.secondary,
  );

  factory PrimaryButton.secondary({
    required String label,
    Function()? onPressed,
    final double? height,
    bool isHighlightAction = false,
  }) {
    return PrimaryButton(
      label: label,
      onPressed: onPressed,
      height: height ?? _defaultHeightButton,
      backgroundColor: AppColors.primaryLight,
      textColor: isHighlightAction ? AppColors.expenseRed : AppColors.primary,
      // borderColor:
      //     isHighlightAction ? AppColors.expenseRed : AppColors.neutral7,
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
      child:
          child ??
          Container(
            height: height,
            padding: AppDimensions.xSmallPaddingHorizontal,
            width: AppDimensions.getSize(context).width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  onPressed == null || isDisable
                      ? AppColors.neutral8
                      : backgroundColor ?? AppColors.primary,
              borderRadius: AppDimensions.largeBorderRadius,
              border:
                  borderColor != null ? Border.all(color: borderColor!) : null,
            ),
            child: PrimaryText(
              label,
              textAlign: TextAlign.center,
              color:
                  onPressed == null || isDisable
                      ? AppColors.neutral6
                      : textColor ?? Colors.white,
              bold: true,
            ),
          ),
    );
  }
}
