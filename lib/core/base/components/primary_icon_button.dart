import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = AppDimensions.largeHeightButton,
    this.iconSize = AppDimensions.mediumIconSize,
    this.iconColor = AppColors.neutral2,
    this.backgroundColor = Colors.white,
    this.borderRadius = AppDimensions.mediumBorderRadius,
    this.borderColor = const Color(0xFFF0E9E2),
    this.borderWidth = AppDimensions.mediumBorderStroke,
    this.boxShadow,
    this.badgeText,
    this.showBadgeDot = false,
    this.badgeColor = AppColors.error,
    this.badgeTextColor = Colors.white,
    this.isDisable = false,
  });

  final Widget icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final String? badgeText;
  final bool showBadgeDot;
  final Color badgeColor;
  final Color badgeTextColor;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        PrimaryAnimatedPressableWidget(
          onTap: isDisable ? null : onTap,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: boxShadow ?? [PrimaryBoxShadows.defaultShadow],
            ),
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: iconSize),
              child: icon,
            ),
          ),
        ),
        if (badgeText != null || showBadgeDot)
          Positioned(
            top: -AppDimensions.xxSmallSpacing,
            right: -AppDimensions.xxSmallSpacing,
            child: _PrimaryIconButtonBadge(
              badgeText: badgeText,
              showBadgeDot: showBadgeDot,
              badgeColor: badgeColor,
              badgeTextColor: badgeTextColor,
            ),
          ),
      ],
    );
  }
}

class _PrimaryIconButtonBadge extends StatelessWidget {
  const _PrimaryIconButtonBadge({
    this.badgeText,
    required this.showBadgeDot,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  final String? badgeText;
  final bool showBadgeDot;
  final Color badgeColor;
  final Color badgeTextColor;

  @override
  Widget build(BuildContext context) {
    if (showBadgeDot && badgeText == null) {
      return Container(
        width: AppDimensions.xSmallSpacing,
        height: AppDimensions.xSmallSpacing,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xxSmallSpacing,
        vertical: AppDimensions.xxxSmallSpacing,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppDimensions.smallRadius),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: PrimaryText(
        badgeText,
        style: AppTextStyles.labelXSmall.copyWith(fontSize: 9),
        color: badgeTextColor,
      ),
    );
  }
}
