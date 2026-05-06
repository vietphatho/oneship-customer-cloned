import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Edge Insets
  // Padding
  static const EdgeInsets xxxSmallPaddingAll = EdgeInsets.all(xxxSmallSpacing);
  static const EdgeInsets xxxSmallPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: xxxSmallSpacing,
  );
  static const EdgeInsets xxxSmallPaddingVertical = EdgeInsets.symmetric(
    vertical: xxxSmallSpacing,
  );

  static const EdgeInsets xxSmallPaddingAll = EdgeInsets.all(xxSmallSpacing);
  static const EdgeInsets xxSmallPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: xxSmallSpacing,
  );
  static const EdgeInsets xxSmallPaddingVertical = EdgeInsets.symmetric(
    vertical: xxSmallSpacing,
  );

  static const EdgeInsets xSmallPaddingAll = EdgeInsets.all(xSmallSpacing);
  static const EdgeInsets xSmallPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: xSmallSpacing,
  );
  static const EdgeInsets xSmallPaddingVertical = EdgeInsets.symmetric(
    vertical: xSmallSpacing,
  );

  static const EdgeInsets smallPaddingAll = EdgeInsets.all(smallSpacing);
  static const EdgeInsets smallPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: smallSpacing,
  );
  static const EdgeInsets smallPaddingVertical = EdgeInsets.symmetric(
    vertical: smallSpacing,
  );

  static const EdgeInsets mediumPaddingAll = EdgeInsets.all(mediumSpacing);
  static const EdgeInsets mediumPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: mediumSpacing,
  );
  static const EdgeInsets mediumPaddingVertical = EdgeInsets.symmetric(
    vertical: mediumSpacing,
  );

  static const EdgeInsets largePaddingAll = EdgeInsets.all(largeSpacing);
  static const EdgeInsets largePaddingHorizontal = EdgeInsets.symmetric(
    horizontal: largeSpacing,
  );
  static const EdgeInsets largePaddingVertical = EdgeInsets.symmetric(
    vertical: largeSpacing,
  );

  static const EdgeInsets xLargePaddingAll = EdgeInsets.all(xLargeSpacing);
  static const EdgeInsets xLargePaddingHorizontal = EdgeInsets.symmetric(
    horizontal: xLargeSpacing,
  );
  static const EdgeInsets xLargePaddingVertical = EdgeInsets.symmetric(
    vertical: xLargeSpacing,
  );

  static const EdgeInsets xxLargePaddingAll = EdgeInsets.all(xxLargeSpacing);
  static const EdgeInsets xxLargePaddingHorizontal = EdgeInsets.symmetric(
    horizontal: xxLargeSpacing,
  );
  static const EdgeInsets xxLargePaddingVertical = EdgeInsets.symmetric(
    vertical: xxLargeSpacing,
  );

  static const EdgeInsets xxxLargePaddingAll = EdgeInsets.all(xxxLargeSpacing);
  static const EdgeInsets xxxLargePaddingHorizontal = EdgeInsets.symmetric(
    horizontal: xxxLargeSpacing,
  );
  static const EdgeInsets xxxLargePaddingVertical = EdgeInsets.symmetric(
    vertical: xxxLargeSpacing,
  );

  static const double smallHeightButton = 36;
  static const double mediumHeightButton = 48;
  static const double largeHeightButton = 56;

  static const double tabBarHeight = 48.0;
  static const double dropdownMenuHeight = 240.0;

  // Spacing
  static const double xxxSmallSpacing = 2;
  static const double xxSmallSpacing = 4;
  static const double xSmallSpacing = 8;
  static const double smallSpacing = 12;
  static const double mediumSpacing = 16;
  static const double largeSpacing = 20;
  static const double xLargeSpacing = 24;
  static const double xxLargeSpacing = 28;
  static const double xxxLargeSpacing = 32;

  static const double smallBorderStroke = 0.6;
  static const double mediumBorderStroke = 0.8;

  // Border Radius
  static const double xSmallRadius = 4.0;
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double xLargeRadius = 20.0;
  static const double xxLargeRadius = 24.0;

  // Default Dimensions
  static const double defaultHeightOfSwitch = 32.0;
  static const double defaultAvatarRadius = 40.0;
  static const double homeAvatarRadius = 24.0;

  // Screen Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Icon Size
  static const double xxSmallIconSize = 12;
  static const double xSmallIconSize = 16;
  static const double smallIconSize = 20;
  static const double mediumIconSize = 24;
  static const double largeIconSize = 28;
  static const double displayIconSize = 56;

  static const double myLocationIconSize = 36;

  // Border Radius
  static const BorderRadius xSmallBorderRadius = BorderRadius.all(
    Radius.circular(xSmallRadius),
  );
  static const BorderRadius smallBorderRadius = BorderRadius.all(
    Radius.circular(smallRadius),
  );
  static const BorderRadius mediumBorderRadius = BorderRadius.all(
    Radius.circular(mediumRadius),
  );
  static const BorderRadius largeBorderRadius = BorderRadius.all(
    Radius.circular(largeRadius),
  );
  static const BorderRadius xLargeBorderRadius = BorderRadius.all(
    Radius.circular(xLargeRadius),
  );

  // Responsive helper methods
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isTablet(context)) return mediumSpacing * 1.5;
    return mediumSpacing;
  }

  static Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // static double getScreenWidth([BuildContext? context]) {
  //   return MediaQuery.of(context ?? AppNavigator.globalContext).size.width;
  // }

  // static double getScreenHeight([BuildContext? context]) {
  //   return MediaQuery.of(context ?? AppNavigator.globalContext).size.height;
  // }

  // static double getWidthIdCard() {
  //   return getScreenWidth() * 0.9;
  // }

  // static double getHeightIdCard() {
  //   return getWidthIdCard() / ratioIdCard;
  // }
}
