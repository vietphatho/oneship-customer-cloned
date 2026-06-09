import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';

class ShopStaffManagementHeader extends StatelessWidget {
  const ShopStaffManagementHeader({
    super.key,
    required this.onBack,
    required this.onSearch,
    required this.onFilter,
    this.hasActiveFilter = false,
  });

  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onFilter;
  final bool hasActiveFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.neutral2,
        ),
        AppSpacing.horizontal(AppDimensions.xSmallSpacing),
        Expanded(
          child: PrimaryText(
            'shop_management.staff_title'.tr(),
            style: AppTextStyles.titleLarge,
          ),
        ),
        PrimaryIconButton(
          icon: const Icon(Icons.search_rounded),
          onTap: onSearch,
          size: 42,
          boxShadow: const [],
          borderColor: Colors.transparent,
        ),
        AppSpacing.horizontal(AppDimensions.xSmallSpacing),
        PrimaryIconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onTap: onFilter,
          size: 42,
          showBadgeDot: hasActiveFilter,
          boxShadow: const [],
          borderColor: Colors.transparent,
        ),
      ],
    );
  }
}

class ShopStaffStats extends StatelessWidget {
  const ShopStaffStats({
    super.key,
    required this.total,
    required this.active,
    required this.locked,
  });

  final int total;
  final int active;
  final int locked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Tổng nhân viên',
            value: total,
            icon: Icons.groups_outlined,
            illustrationIcon: Icons.groups_rounded,
            color: AppColors.warningForeground,
            backgroundColor: AppColors.warningBackground,
          ),
        ),
        AppSpacing.horizontal(AppDimensions.xSmallSpacing),
        Expanded(
          child: _StatCard(
            label: 'shop_management.status_active'.tr(),
            value: active,
            icon: Icons.person_outline_rounded,
            illustrationIcon: Icons.verified_rounded,
            color: AppColors.successForeground,
            backgroundColor: AppColors.successBackground,
          ),
        ),
        AppSpacing.horizontal(AppDimensions.xSmallSpacing),
        Expanded(
          child: _StatCard(
            label: 'locked'.tr(),
            value: locked,
            icon: Icons.lock_outline_rounded,
            illustrationIcon: Icons.lock_rounded,
            color: AppColors.errorForeground,
            backgroundColor: AppColors.errorBackground,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.illustrationIcon,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final int value;
  final IconData icon;
  final IconData illustrationIcon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return PrimaryPanel(
      height: 144,
      padding: AppDimensions.smallPaddingAll,
      backgroundColor: backgroundColor,
      borderColor: color.withOpacity(0.2),
      boxShadow: const [],
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -12,
            child: Icon(
              illustrationIcon,
              size: 64,
              color: color.withOpacity(0.16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.onPrimary, size: 20),
                  ),
                  AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
                  Expanded(
                    child: PrimaryText(
                      label,
                      style: AppTextStyles.labelXSmall.copyWith(fontSize: 10),
                      maxLine: 2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PrimaryText(
                value.toString(),
                style: AppTextStyles.titleXXLarge.copyWith(fontSize: 30),
                color: color,
              ),
              PrimaryText(
                'Người',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                color: AppColors.neutral3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
