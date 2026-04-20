import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFF58220);
  static const Color primaryLight = Color.fromARGB(255, 253, 229, 207);
  static const Color primaryDark = Color.fromARGB(255, 211, 106, 14);
  // static const Color primaryContainer = Color(0xFFE8F5E8);

  static const Color secondary = Color(0xFF2765B0);
  // static const Color secondaryLight = Color(0xFFFF9800);
  static const Color secondaryDark = Color.fromARGB(255, 159, 221, 252);
  // static const Color secondaryContainer = Color(0xFFFFF3E0);

  // Expense Categories Colors
  static const Color expenseRed = Color(0xFFE53E3E);
  static const Color incomeGreen = Color(0xFF38A169);
  static const Color savingsBlue = Color(0xFF3182CE);
  static const Color investmentPurple = Color(0xFF805AD5);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Light Scheme Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color dialogBarrierColor = Color(0x50000000);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainerHigh = Color(0xFFedf4ff);
  static const Color surfaceVariant = Color.fromARGB(255, 240, 247, 255);
  static const Color outline = neutral8;
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = neutral3;
  static const Color onSurfaceVariant = neutral2;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Dark Scheme Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color dialogBarrierColorDark = Color(0xA0000000);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceContainerHighDark = neutral3;
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  static const Color onBackgroundDark = Color(0xFFE1E1E1);
  static const Color onSurfaceDark = Color(0xFFE1E1E1);
  static const Color onSurfaceVariantDark = Colors.white;
  static const Color darkOutline = neutral2;

  // Neutral colors
  static const Color neutral1 = Color(0xFF1F1F1F);
  static const Color neutral2 = Color(0xFF333333);
  static const Color neutral3 = Color(0xFF44494D);
  static const Color neutral4 = Color(0xFF666666);
  static const Color neutral5 = Color(0xFF808080);
  static const Color neutral6 = Color(0xFF999999);
  static const Color neutral7 = Color(0xFFD1D2D2);
  static const Color neutral8 = Color(0xFFE9EAEB);
  static const Color neutral9 = Color(0xFFF5F5F5);

  // Accent Colors
  static const Color warningBackground1 = Color(0xFFFFFAEB);
  static const Color moneyInColor = Color(0xFF12B76A);
  static const Color moneyOutColor = Color(0xFFF04438);
  static const Color accentColor1 = Color.fromARGB(255, 105, 169, 201);
  static const Color accentColor2 = Color.fromARGB(255, 210, 240, 255);

  // Gradient Colors
  // static const LinearGradient primaryGradient = LinearGradient(
  //   colors: [primary, primaryLight],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFFF44336), // Red
    Color(0xFF00BCD4), // Cyan
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
  ];

  static const Color backgroundColor = Color(0xFFFDFDFD);
  static const Color grey600 = Color(0xFF535862);
  static const Color blue950 = Color(0xFF101A24);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey400 = Color(0xFFA4A7AE);
  static const Color grey300 = Color(0xFFD5D7DA);
  static const Color orange = Color(0xFFDA702C);
  static const Color green100 = Color(0xFFD1FAE5);
  static const Color green600 = Color(0xFF059669);
  static const Color grey200 = Color(0xFFE9EAEB);
  static const Color brown600 = Color(0xFF6F6E69);
  static const Color green400 = Color(0xFF34D399);
  static const Color grey500 = Color(0xFF717680);
  static const Color green = Color(0xFF12B76A);
  static const Color grey900 = Color(0xFF646464);
  static const Color orange100 = Color(0xFFF79009);
  static const Color green800 = Color(0xFF05603A);
  static const Color red500 = Color(0xFFC03E35);
  static const Color grey800 = Color(0xFF252B37);
  static const Color blue100 = Color(0xFFBAE0FF);

  static const Color bottomNavBarBackgroundDark = Color(0xFF101A24);
  static const Color bottomNavBarBackground = neutral9;
}
