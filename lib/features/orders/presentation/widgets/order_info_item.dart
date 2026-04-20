import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';

class OrderInfoItem extends StatelessWidget {
  const OrderInfoItem({super.key, required this.order, required this.index});

  final int index;
  final OrderInfo order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.xSmallSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    PrimaryText("#$index.", style: AppTextStyles.bodyMedium),
                    AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
                    Expanded(
                      child: PrimaryText(
                        order.orderNumber,
                        style: AppTextStyles.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.accentColor1,
                  borderRadius: AppDimensions.mediumBorderRadius,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: AppDimensions.xxSmallSpacing,
                  horizontal: AppDimensions.xSmallSpacing,
                ),
                child: PrimaryText(
                  order.status,
                  style: AppTextStyles.labelSmall,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          PrimaryText(
            "${order.customerName} - ${order.phone}",
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral4,
          ),
          AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
          PrimaryText(
            "${"cod".tr()}: ${order.codAmount}",
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral4,
          ),
          AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
          PrimaryText(
            "${"created_at".tr()}: ${order.createdAt}",
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral4,
          ),
        ],
      ),
    );
  }
}
