import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Font Family
  static const String fontFamily = 'Afacad Flux';

  //default text style
  static TextStyle defaultTextStyle = TextStyle(
    decoration: TextDecoration.none,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontFamily: AppTextStyles.fontFamily,
  );

  // Title Styles (Small headers)
  static const TextStyle titleXXXLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );

  static const TextStyle titleXXLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );

  static const TextStyle titleXLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );

  // Label Styles (Buttons, tabs)
  static TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  static const TextStyle labelXSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  // Body Styles (Regular text)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyXSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyCompact = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyXXSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
  );

  static const TextStyle smallButtonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
  );

  static const TextStyle hintText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral6,
  );

  static const TextStyle errorText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: AppColors.error,
  );

  // Dark theme variants
  /////////////
  static TextStyle get titleXXXLargeDark =>
      titleXXLarge.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get titleXXLargeDark =>
      titleXXLarge.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get titleXLargeDark =>
      titleXLarge.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get titleLargeDark =>
      titleLarge.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get titleMediumDark =>
      titleMedium.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get titleSmallDark =>
      titleSmall.copyWith(color: AppColors.onBackgroundDark);

  /////////////
  static TextStyle get labelLargeDark =>
      labelLarge.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get labelMediumDark =>
      labelMedium.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get labelSmallDark =>
      labelSmall.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get labelXSmallDark =>
      labelXSmall.copyWith(color: AppColors.onBackgroundDark);

  /////////////
  static TextStyle get bodyLargeDark =>
      bodyLarge.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get bodyMediumDark =>
      bodyMedium.copyWith(color: AppColors.onBackgroundDark);
  static TextStyle get bodySmallDark =>
      bodySmall.copyWith(color: AppColors.onBackgroundDark);

  static TextStyle get hintTextDark =>
      hintText.copyWith(color: AppColors.onSurfaceVariantDark);
}
