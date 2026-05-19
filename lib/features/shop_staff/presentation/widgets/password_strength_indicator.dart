import 'package:oneship_customer/core/base/base_import_components.dart';

enum PasswordStrength {
  empty,
  weak,
  medium,
  strong;

  static PasswordStrength fromValue(String value) {
    if (value.isEmpty) return empty;

    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[^A-Za-z0-9]').hasMatch(value);
    final rulesPassed = [
      hasLowercase,
      hasUppercase,
      hasNumber,
      hasSpecial,
    ].where((rule) => rule).length;

    if (value.length >= 8 && rulesPassed >= 4) return strong;
    if (value.length >= 8 && rulesPassed >= 2) return medium;
    return weak;
  }

  Color get color {
    switch (this) {
      case PasswordStrength.strong:
        return AppColors.green600;
      case PasswordStrength.medium:
        return AppColors.warning;
      case PasswordStrength.weak:
        return AppColors.red500;
      case PasswordStrength.empty:
        return AppColors.neutral8;
    }
  }

  String get labelKey {
    switch (this) {
      case PasswordStrength.strong:
        return "shop_management.staff_password_strength_strong";
      case PasswordStrength.medium:
        return "shop_management.staff_password_strength_medium";
      case PasswordStrength.weak:
        return "shop_management.staff_password_strength_weak";
      case PasswordStrength.empty:
        return "";
    }
  }
}

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.strength});

  final PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.empty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.xxSmallSpacing),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: AppDimensions.xSmallBorderRadius,
            child: LinearProgressIndicator(
              value: 1,
              minHeight: 3,
              color: strength.color,
              backgroundColor: AppColors.neutral8,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xxSmallSpacing),
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryText(
              strength.labelKey.tr(),
              style: AppTextStyles.bodyMedium,
              color: strength.color,
            ),
          ),
        ],
      ),
    );
  }
}
