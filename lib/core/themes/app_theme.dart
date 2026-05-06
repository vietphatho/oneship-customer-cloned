import 'package:oneship_customer/core/base/base_import_components.dart';

// extension AppColorsExt on Color {
//   Color valueOpacity(double opacity) {
//     return withValues(alpha: opacity);
//   }
// }

class AppTheme {
  AppTheme._();

  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static ColorScheme getColorScheme(BuildContext context) =>
      Theme.of(context).colorScheme;

  static TextTheme getTextTheme(BuildContext context) =>
      Theme.of(context).textTheme;

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      surfaceContainer: AppColors.surface,
      surface: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      outline: AppColors.outline,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      shadow: AppColors.neutral6,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    disabledColor: AppColors.neutral6,
    dialogTheme: const DialogThemeData(
      barrierColor: AppColors.dialogBarrierColor,
    ),
    primaryTextTheme: const TextTheme(bodyMedium: AppTextStyles.bodyMedium),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.primary,
      iconTheme: IconThemeData(color: AppColors.primary),
    ),
    dividerColor: AppColors.grey200,
    dividerTheme: const DividerThemeData(color: AppColors.grey200),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    tabBarTheme: const TabBarTheme(
      // indicator: BoxDecoration(
      //   // color: AppColors.primary,
      //   borderRadius: AppDimensions.smallBorderRadius,
      // ),
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.primary,
      labelStyle: AppTextStyles.titleSmall,
      unselectedLabelStyle: AppTextStyles.bodySmall,
      unselectedLabelColor: AppColors.neutral5,
      dividerColor: Colors.transparent,
      indicatorAnimation: TabIndicatorAnimation.elastic,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      strokeCap: StrokeCap.round,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => Colors.white,
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.neutral7;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => Colors.transparent,
      ),
      trackOutlineWidth: WidgetStateProperty.resolveWith<double>(
        (Set<WidgetState> states) => 0,
      ),
      padding: const EdgeInsets.all(0),
    ),
    primaryColorLight: AppColors.primary,
    primaryColor: AppColors.primary,
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      // Header
      headerBackgroundColor: AppColors.neutral9,
      headerForegroundColor: AppColors.neutral2,
      headerHelpStyle: const TextStyle(color: AppColors.neutral2),

      // Day cell
      dayForegroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.neutral7;
        }

        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.neutral3;
      }),
      dayBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return Colors.transparent;
      }),
      todayBorder: const BorderSide(color: AppColors.primary, width: 1),
      todayForegroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.neutral7;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.backgroundColor;
        }
        return AppColors.primary;
      }),
      todayBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return Colors.transparent;
      }),
      yearBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return Colors.transparent;
      }),
      yearForegroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.neutral3;
      }),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith((_) => AppColors.primary),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith((_) => AppColors.primary),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      surfaceContainer: AppColors.surfaceDark,
      surface: AppColors.surfaceDark,
      surfaceContainerHigh: AppColors.surfaceContainerHighDark,
      outline: AppColors.darkOutline,
      onSurface: AppColors.onSurfaceDark,
      onSurfaceVariant: AppColors.onSurfaceVariantDark,
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
    ),
    disabledColor: AppColors.neutral4,
    dialogTheme: const DialogThemeData(
      barrierColor: AppColors.dialogBarrierColorDark,
    ),
    primaryTextTheme: TextTheme(
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.onSurfaceDark,
      ),
      bodyLarge: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.onSurfaceDark,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.onSurfaceDark,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: AppColors.onSurfaceDark,
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.onSurfaceDark,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: AppColors.onSurfaceDark,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: AppColors.backgroundDark),
    ),
    dividerColor: AppColors.neutral2,
    dividerTheme: const DividerThemeData(
      color: AppColors.neutral2,
      thickness: 0.5,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    tabBarTheme: const TabBarTheme(
      indicator: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppDimensions.smallBorderRadius,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.white,
      labelStyle: AppTextStyles.titleSmall,
      unselectedLabelColor: AppColors.neutral6,
      unselectedLabelStyle: AppTextStyles.titleSmall,
      dividerColor: Colors.transparent,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => Colors.white,
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryDark;
        }
        return AppColors.neutral7;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => Colors.transparent,
      ),
      trackOutlineWidth: WidgetStateProperty.resolveWith<double>(
        (Set<WidgetState> states) => 0,
      ),
      padding: const EdgeInsets.all(0),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryDark,
      strokeCap: StrokeCap.round,
    ),
    primaryColorLight: AppColors.primaryDark,
    primaryColor: AppColors.primaryDark,
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.neutral2.withAlpha(200),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),

      // Header
      headerBackgroundColor: AppColors.neutral3.withAlpha(200),
      headerForegroundColor: Colors.white,
      headerHelpStyle: const TextStyle(color: AppColors.neutral9),

      // Day cell
      dayForegroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.neutral3;
        }

        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.neutral7;
      }),
      dayBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return Colors.transparent;
      }),
      todayBorder: const BorderSide(color: AppColors.primaryDark, width: 1),
      todayForegroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.neutral3;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.backgroundDark;
        }
        return AppColors.primaryDark;
      }),
      todayBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primaryDark;
        return Colors.transparent;
      }),
      yearBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primaryDark;
        return Colors.transparent;
      }),
      yearForegroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.neutral3;
      }),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith(
          (_) => AppColors.primaryDark,
        ),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith(
          (_) => AppColors.primaryDark,
        ),
      ),
    ),
  );
}
