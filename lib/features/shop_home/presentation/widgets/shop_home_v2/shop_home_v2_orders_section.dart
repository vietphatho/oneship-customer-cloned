part of '../../views/shop_home_v2.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return PrimaryText(
      title,
      style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
    );
  }
}


class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.largeBorderRadius,
        border: Border.all(color: AppColors.shopHomeV2InputBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryText(
              'Tìm kiếm đơn hàng...',
              style: AppTextStyles.bodyXSmall.copyWith(
                color: AppColors.neutral5,
                fontSize: 13,
              ),
            ),
          ),
          const Icon(Icons.search_rounded, color: AppColors.neutral1, size: 28),
        ],
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs();

  @override
  Widget build(BuildContext context) {
    const tabs = ['Tất cả', 'Chờ lấy hàng', 'Đang giao', 'Đã giao', 'Đã hủy'];

    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.largeBorderRadius,
        border: Border.all(color: AppColors.shopHomeV2InputBorder),
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tab == 'Tất cả'
                      ? AppColors.shopHomeV2SelectedTabBackground
                      : Colors.transparent,
                  borderRadius: AppDimensions.mediumBorderRadius,
                  border: tab == 'Tất cả'
                      ? Border.all(color: AppColors.shopHomeV2SelectedTabBorder)
                      : null,
                ),
                child: PrimaryText(
                  tab,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelXSmall.copyWith(
                    color: tab == 'Tất cả'
                        ? AppColors.primary
                        : AppColors.neutral5,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _OrderCard(
          iconPath: ImagePath.shopHomeV2OrderStatusWaiting,
          lineColor: AppColors.primary,
          code: '#ON12345678',
          name: 'Nguyễn Văn An',
          address: '123 Nguyễn Trãi, Phường 3, Quận 5...',
          status: 'Chờ lấy hàng',
          statusColor: AppColors.primary,
          price: '120.000đ',
          time: '10/05/2025  •  14:30',
        ),
        _OrderCard(
          iconPath: ImagePath.shopHomeV2OrderStatusDelivery,
          lineColor: AppColors.shopHomeV2Delivery,
          code: '#ON12345679',
          name: 'Trần Thị Bích Ngọc',
          address: '78 Lê Hồng Phong, Phường 2, Quận 10...',
          status: 'Đang giao',
          statusColor: AppColors.shopHomeV2Delivery,
          price: '85.000đ',
          time: '10/05/2025  •  15:20',
        ),
        _OrderCard(
          iconPath: ImagePath.shopHomeV2OrderStatusDone,
          lineColor: AppColors.successForeground,
          code: '#ON12345680',
          name: 'Lê Minh Tuấn',
          address: '45 Hoàng Văn Thụ, Phường 4, Tân Bình...',
          status: 'Đã giao',
          statusColor: AppColors.successForeground,
          price: '210.000đ',
          time: '09/05/2025  •  17:10',
          isLast: true,
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.iconPath,
    required this.lineColor,
    required this.code,
    required this.name,
    required this.address,
    required this.status,
    required this.statusColor,
    required this.price,
    required this.time,
    this.isLast = false,
  });

  final String iconPath;
  final Color lineColor;
  final String code;
  final String name;
  final String address;
  final String status;
  final Color statusColor;
  final String price;
  final String time;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 18,
          height: 112,
          child: Column(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 29),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: lineColor, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.only(top: 7),
                    color: AppColors.shopHomeV2TimelineLine,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 98,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppDimensions.largeBorderRadius,
              boxShadow: [PrimaryBoxShadows.defaultShadow],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Image.asset(iconPath, width: 42, height: 42),
                  ),
                ),
                AppSpacing.horizontal(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryText(
                        code,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelXSmall.copyWith(fontSize: 13),
                      ),
                      AppSpacing.vertical(3),
                      PrimaryText(
                        name,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelXSmall.copyWith(fontSize: 12),
                      ),
                      AppSpacing.vertical(2),
                      PrimaryText(
                        address,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyXXSmall.copyWith(
                          color: AppColors.neutral5,
                          fontSize: 10,
                        ),
                      ),
                      AppSpacing.vertical(5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(18),
                              borderRadius: AppDimensions.smallBorderRadius,
                            ),
                            child: PrimaryText(
                              status,
                              style: AppTextStyles.bodyXXSmall.copyWith(
                                color: statusColor,
                                fontSize: 10,
                                height: 1,
                              ),
                            ),
                          ),
                          AppSpacing.horizontal(8),
                          Expanded(
                            child: PrimaryText(
                              time,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyXXSmall.copyWith(
                                color: AppColors.neutral5,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontal(8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryText(
                      price,
                      style: AppTextStyles.labelXSmall.copyWith(fontSize: 15),
                    ),
                    AppSpacing.vertical(8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.neutral5,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}




