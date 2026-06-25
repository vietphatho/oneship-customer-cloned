import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_bloc.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';

class VendorOrderCard extends StatelessWidget {
  const VendorOrderCard({super.key, required this.order, required this.tab});

  final VendorOrderEntity order;
  final VendorOrdersTab tab;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);
    final iconPath = _iconPath(order.status);
    final createdAt =
        DateTimeUtils.formatDateTime(order.createdAt?.toLocal()) ?? '--';
    final totalAmount = order.collectAmount ?? order.codAmount ?? 0;

    return PrimaryAnimatedPressableWidget(
      onTap: () => getIt.get<VendorOrdersBloc>().openOrderDetail(order, tab),
      child: PrimaryFrame(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.smallSpacing,
          vertical: AppDimensions.xSmallSpacing,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(iconPath, width: 42, height: 42)),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    '#${order.trackingCode ?? '--'}',
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelSmall,
                  ),
                  AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                  PrimaryText(
                    order.customerName ?? '--',
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyXSmall,
                    color: AppColors.neutral5,
                  ),
                  AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                  PrimaryText(
                    order.fullAddress ?? '--',
                    maxLine: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyXSmall,
                    color: AppColors.neutral5,
                  ),
                  AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                  PrimaryText(
                    Utils.formatCurrencyWithUnit(totalAmount),
                    style: AppTextStyles.labelXSmall,
                  ),
                  AppSpacing.vertical(AppDimensions.xSmallSpacing),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.xSmallSpacing,
                          vertical: AppDimensions.xxSmallSpacing,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(18),
                          borderRadius: AppDimensions.smallBorderRadius,
                        ),
                        child: PrimaryText(
                          (order.status ?? '--').tr(),
                          style: AppTextStyles.bodyXXSmall.copyWith(
                            color: statusColor,
                            fontSize: 10,
                            height: 1,
                          ),
                        ),
                      ),
                      AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                      Expanded(
                        child: PrimaryText(
                          createdAt,
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
          ],
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivering':
      case 'in_transit':
        return AppColors.shopHomeV2Delivery;
      case 'delivered':
      case 'completed':
        return AppColors.successForeground;
      case 'cancelled':
      case 'canceled':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String _iconPath(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivering':
      case 'in_transit':
        return ImagePath.shopHomeV2OrderStatusDelivery;
      case 'delivered':
      case 'completed':
        return ImagePath.shopHomeV2OrderStatusDone;
      default:
        return ImagePath.shopHomeV2OrderStatusWaiting;
    }
  }
}
