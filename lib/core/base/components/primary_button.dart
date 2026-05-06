import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  final bool isDisable;
  // final Widget? child;
  final double height;

  final Widget? icon;

  const PrimaryButton._({
    super.key,
    required this.onPressed,
    this.label = "",
    this.backgroundColor,
    this.isDisable = false,
    // this.child,
    this.height = AppDimensions.mediumHeightButton,
    this.borderColor,
    this.textColor,
    this.icon,
  });

  factory PrimaryButton.filled({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
  }) => PrimaryButton._(
    label: label,
    onPressed: onPressed,
    height: height,
    textColor: Colors.white,
    backgroundColor: AppColors.primary,
  );

  factory PrimaryButton.outlined({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
  }) {
    return PrimaryButton._(
      label: label,
      onPressed: onPressed,
      height: height,
      backgroundColor: Colors.white,
      textColor: AppColors.primary,
      borderColor: AppColors.primary,
    );
  }

  factory PrimaryButton.iconFilled({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
    required Widget icon,
  }) => PrimaryButton._(
    label: label,
    onPressed: onPressed,
    height: height,
    textColor: Colors.white,
    backgroundColor: AppColors.primary,
    icon: icon,
  );

  factory PrimaryButton.iconOutlined({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
    required Widget icon,
  }) {
    return PrimaryButton._(
      label: label,
      onPressed: onPressed,
      height: height,
      backgroundColor: Colors.white,
      textColor: AppColors.primary,
      borderColor: AppColors.primary,
      icon: icon,
    );
  }

  factory PrimaryButton.warningFilled({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
  }) => PrimaryButton._(
    label: label,
    onPressed: onPressed,
    height: height,
    textColor: Colors.white,
    backgroundColor: AppColors.red500,
  );

  factory PrimaryButton.warningOutlined({
    required String label,
    Function()? onPressed,
    double height = AppDimensions.mediumHeightButton,
  }) {
    return PrimaryButton._(
      label: label,
      onPressed: onPressed,
      height: height,
      backgroundColor: Colors.white,
      textColor: AppColors.red500,
      borderColor: AppColors.red500,
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
          border: borderColor != null ? Border.all(color: borderColor!) : null,
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
