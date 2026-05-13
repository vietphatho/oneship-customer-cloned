import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_detail_entity.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_badges.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_detail_section.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/staff_permission_config.dart';

class ShopStaffDetailContent extends StatelessWidget {
  const ShopStaffDetailContent({super.key, required this.staff});

  final ShopStaffDetailEntity staff;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        AppDimensions.xSmallSpacing,
        AppDimensions.mediumSpacing,
        AppDimensions.mediumSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryText(
            "shop_management.staff_header".tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium,
            bold: true,
          ),
          AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
          PrimaryText(
            staff.displayName,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral4,
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          SecondaryButton.iconFilled(
            label: "shop_management.staff_add_shop_for_staff".tr(),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: AppDimensions.smallIconSize,
            ),
            onPressed:
                () => context.push(
                  RouteName.addShopToStaffPage,
                  extra: staff,
                ),
            height: AppDimensions.smallHeightButton,
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          _PersonalInfoSection(staff: staff),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          _ShopInfoSection(staff: staff),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          _TimeInfoSection(staff: staff),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          _PermissionInfoSection(staff: staff),
        ],
      ),
    );
  }
}

class _PersonalInfoSection extends StatelessWidget {
  const _PersonalInfoSection({required this.staff});

  final ShopStaffDetailEntity staff;

  @override
  Widget build(BuildContext context) {
    return ShopStaffDetailSection(
      icon: Icons.person,
      title: "shop_management.staff_personal_info".tr(),
      children: [
        ShopStaffInfoRow(
          label: "shop_management.staff_username".tr(),
          value: staff.userLogin,
        ),
        ShopStaffInfoRow(
          label: "shop_management.staff_full_name".tr(),
          value: staff.displayName,
        ),
        ShopStaffInfoRow(
          label: "shop_management.field_email".tr(),
          value: staff.userEmail,
        ),
        ShopStaffInfoRow(
          label: "shop_management.field_phone".tr(),
          value: staff.userPhone,
        ),
        ShopStaffInfoRow(
          label: "shop_management.staff_role".tr(),
          trailing: ShopStaffRoleBadge(role: staff.role),
        ),
        ShopStaffInfoRow(
          label: "shop_management.field_status".tr(),
          trailing: ShopStaffStatusBadge(isActive: staff.isActive),
        ),
      ],
    );
  }
}

class _ShopInfoSection extends StatelessWidget {
  const _ShopInfoSection({required this.staff});

  final ShopStaffDetailEntity staff;

  @override
  Widget build(BuildContext context) {
    return ShopStaffDetailSection(
      icon: Icons.store,
      title: "shop_management.staff_shop_info".tr(),
      children: [
        ShopStaffInfoRow(
          label: "shop_management.field_name".tr(),
          value: staff.shopName,
        ),
        ShopStaffInfoRow(
          label: "shop_management.staff_shop_status".tr(),
          trailing: ShopStaffStatusBadge(isActive: staff.isShopActive),
        ),
      ],
    );
  }
}

class _TimeInfoSection extends StatelessWidget {
  const _TimeInfoSection({required this.staff});

  final ShopStaffDetailEntity staff;

  @override
  Widget build(BuildContext context) {
    return ShopStaffDetailSection(
      icon: Icons.access_time,
      title: "shop_management.staff_time".tr(),
      children: [
        ShopStaffInfoRow(
          label: "shop_management.field_created_at".tr(),
          value: _formatDateTime(staff.createdAt),
        ),
        ShopStaffInfoRow(
          label: "shop_management.staff_updated_at".tr(),
          value: _formatDateTime(staff.updatedAt),
        ),
      ],
    );
  }

  String _formatDateTime(String value) {
    final dateTime = DateTime.tryParse(value);
    if (dateTime == null) return DateTimeUtils.formatterString(value);
    final date = DateTimeUtils.formatDateTime(
      dateTime.toLocal(),
      format: Constants.defaultDateFormat,
    );
    final time = DateTimeUtils.formatTimeFromDT(dateTime.toLocal());
    return "$date $time";
  }
}

class _PermissionInfoSection extends StatelessWidget {
  const _PermissionInfoSection({required this.staff});

  final ShopStaffDetailEntity staff;

  @override
  Widget build(BuildContext context) {
    return ShopStaffDetailSection(
      icon: Icons.layers,
      title: "shop_management.staff_permission".tr(),
      trailing: const Icon(
        Icons.edit_square,
        color: AppColors.secondary,
        size: AppDimensions.xSmallIconSize,
      ),
      children:
          staffPermissionGroups.map((group) {
            return _PermissionGroupView(
              group: group,
              permissions: staff.permissions[group.key] ?? const {},
            );
          }).toList(),
    );
  }
}

class _PermissionGroupView extends StatelessWidget {
  const _PermissionGroupView({
    required this.group,
    required this.permissions,
  });

  final StaffPermissionGroup group;
  final Map<String, bool> permissions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.smallSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            group.labelKey.tr(),
            style: AppTextStyles.titleMedium,
            color: AppColors.neutral4,
            bold: true,
          ),
          AppSpacing.vertical(AppDimensions.xxSmallSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                staffPermissionActions.map((action) {
                  final isEnabled = permissions[action.key] == true;
                  return _PermissionItem(
                    label: action.labelKey.tr(),
                    isEnabled: isEnabled,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  const _PermissionItem({required this.label, required this.isEnabled});

  final String label;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isEnabled ? Icons.check_circle : Icons.cancel,
          color: isEnabled ? AppColors.green600 : AppColors.neutral7,
          size: AppDimensions.xxSmallIconSize,
        ),
        AppSpacing.horizontal(AppDimensions.xxxSmallSpacing),
        PrimaryText(
          label,
          style: AppTextStyles.labelSmall,
          color: isEnabled ? AppColors.green600 : AppColors.neutral6,
        ),
      ],
    );
  }
}
