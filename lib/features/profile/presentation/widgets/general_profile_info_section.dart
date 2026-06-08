import 'package:oneship_customer/core/base/base_import_components.dart';

class GeneralProfileShopInfoCard extends StatelessWidget {
  const GeneralProfileShopInfoCard({super.key});

  static const List<PrimaryInfoItemData> _items = [
    PrimaryInfoItemData(
      icon: Icons.storefront_outlined,
      iconColor: AppColors.primary,
      label: 'Tên cửa hàng',
      value: 'OneShip Store',
    ),
    PrimaryInfoItemData(
      icon: Icons.verified_user_outlined,
      iconColor: AppColors.green,
      label: 'Mã cửa hàng',
      value: 'OS123456',
    ),
    PrimaryInfoItemData(
      icon: Icons.calendar_month_outlined,
      iconColor: AppColors.info,
      label: 'Ngày tham gia',
      value: '12/05/2025',
    ),
    PrimaryInfoItemData(
      icon: Icons.workspace_premium_outlined,
      iconColor: AppColors.investmentPurple,
      label: 'Gói dịch vụ',
      value: 'Business',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PrimaryPanel(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        AppDimensions.mediumSpacing,
        AppDimensions.mediumSpacing,
        AppDimensions.largeSpacing,
      ),
      child: Column(
        children: [
          Row(
            children: [
              PrimaryText(
                'Thông tin cửa hàng',
                style: AppTextStyles.labelMedium.copyWith(fontSize: 17),
              ),
              const Spacer(),
              PrimaryText(
                'Xem chi tiết',
                style: AppTextStyles.labelXSmall.copyWith(fontSize: 13),
                color: AppColors.primary,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary,
                size: AppDimensions.smallIconSize,
              ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.largeSpacing),
          Row(
            children: [
              for (var i = 0; i < _items.length; i++) ...[
                Expanded(child: PrimaryInfoItem(data: _items[i])),
                if (i != _items.length - 1) const _InfoDivider(),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.mediumBorderStroke,
      height: AppDimensions.displayIconSize,
      color: AppColors.neutral8,
    );
  }
}
