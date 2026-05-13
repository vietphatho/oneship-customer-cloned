import 'package:oneship_customer/core/base/base_import_components.dart';

class ShopStaffStatusBadge extends StatelessWidget {
  const ShopStaffStatusBadge({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xSmallSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.green100 : AppColors.neutral9,
        borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
      ),
      child: PrimaryText(
        isActive
            ? "shop_management.status_active".tr()
            : "shop_management.status_inactive".tr(),
        style: AppTextStyles.labelSmall,
        color: isActive ? AppColors.green800 : AppColors.neutral5,
      ),
    );
  }
}

class ShopStaffRoleBadge extends StatelessWidget {
  const ShopStaffRoleBadge({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xSmallSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
        border: Border.all(color: AppColors.primary, width: 0.8),
      ),
      child: PrimaryText(
        _roleLabel,
        style: AppTextStyles.labelSmall,
        color: AppColors.primary,
      ),
    );
  }

  String get _roleLabel {
    switch (role.trim().toLowerCase()) {
      case "owner":
      case "shop_owner":
      case "shop owner":
        return "shop_management.staff_role_owner".tr();
      case "staff":
      case "employee":
      case "nhân viên":
        return "shop_management.staff_role_employee".tr();
      default:
        return role;
    }
  }
}
