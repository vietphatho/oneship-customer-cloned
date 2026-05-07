import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';

class OrderOfPkgInfoItem extends StatelessWidget {
  const OrderOfPkgInfoItem({
    super.key,
    required this.order,
    required this.index,
  });

  final int index;
  final OrderInfo order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  PrimaryText("#$index.", style: AppTextStyles.bodyMedium),
                  AppSpacing.horizontal(AppDimensions.xSmallSpacing),
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
            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
            Container(
              decoration: BoxDecoration(
                color: AppColors.accentColor1,
                borderRadius: AppDimensions.mediumBorderRadius,
              ),
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.xxxSmallSpacing,
                horizontal: AppDimensions.xSmallSpacing,
              ),
              child: PrimaryText(
                _translateStatus(order.status),
                style: AppTextStyles.bodySmall,
                color: Colors.white,
              ),
            ),
          ],
        ),
        AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
        PrimaryText(
          "${order.customerName} - ${order.phone}",
          style: AppTextStyles.bodyMedium,
        ),
        AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
        PrimaryText(
          "${"service_type".tr()}: ${_translatePayer(order.payer)}",
          style: AppTextStyles.bodyMedium,
        ),
        AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
        PrimaryText(
          "${"address".tr()}: ${order.fullAddress}",
          style: AppTextStyles.bodyMedium,
        ),
        AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
        PrimaryText(
          "${"created_at".tr()}: ${order.createdAt}",
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  String _translateStatus(String? status) {
    final normalized = status?.toLowerCase();
    if (normalized == null || normalized.isEmpty) return "--";
    return normalized.tr();
  }

  String _translatePayer(String? payer) {
    return switch (payer?.toUpperCase()) {
      "SENDER" => "sender".tr(),
      "RECEIVER" => "recipient".tr(),
      _ => payer ?? "--",
    };
  }
}
