import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_entity.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_badges.dart';

class ShopStaffCard extends StatelessWidget {
  const ShopStaffCard({
    super.key,
    required this.index,
    required this.staff,
    this.onViewDetails,
  });

  final int index;
  final ShopStaffEntity staff;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: onViewDetails,
      child: PrimaryFrame(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.mediumSpacing,
          AppDimensions.smallSpacing,
          AppDimensions.mediumSpacing,
          AppDimensions.mediumSpacing,
        ),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                index.toString().padLeft(2, '0'),
                style: AppTextStyles.titleMedium,
                bold: true,
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              _InfoRow(
                label: "shop_management.staff_full_name".tr(),
                value: staff.displayName,
              ),
              _InfoRow(
                label: "shop_management.field_email".tr(),
                value: staff.userEmail,
              ),
              _InfoRow(
                label: "shop_management.field_phone".tr(),
                value: staff.userPhone,
              ),
              _InfoRow(
                label: "shop_management.field_name".tr(),
                value: staff.shopName,
              ),
              _InfoRow(
                label: "shop_management.staff_role".tr(),
                trailing: ShopStaffRoleBadge(role: staff.role),
              ),
              _InfoRow(
                label: "shop_management.field_status".tr(),
                trailing: ShopStaffStatusBadge(isActive: staff.isActive),
              ),
              _InfoRow(
                label: "shop_management.field_created_at".tr(),
                value: DateTimeUtils.formatterString(staff.createdAt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, this.value = "", this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: PrimaryText(
              label,
              style: AppTextStyles.bodyMedium,
              color: AppColors.neutral1,
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value.isNotEmpty)
                  Flexible(
                    child: PrimaryText(
                      value,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.titleMedium,
                      color: AppColors.neutral1,
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (trailing != null) ...[
                  if (value.isNotEmpty)
                    AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
                  trailing!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
