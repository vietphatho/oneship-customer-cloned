import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';

class OrdersHistoryListItem extends StatelessWidget {
  const OrdersHistoryListItem({
    super.key,
    required this.index,
    required this.order,
    this.onTap,
  });

  final int index;
  final OrdersHistoryEntity order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final address = order.fullAddress ?? order.fullAddressOld ?? "--";
    final createdAt = DateTimeUtils.formatDateTime(order.createdAt) ?? "--";
    final cod = Utils.formatCurrencyWithUnit(order.codAmount);

    return PrimaryAnimatedPressableWidget(
      onTap: onTap,
      child: PrimaryFrame(
        padding: const EdgeInsets.all(AppDimensions.smallSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral5,
                      ),
                      children: [
                        TextSpan(
                          text: "#$index. ",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.accentColor1,
                          ),
                        ),
                        TextSpan(
                          text: order.orderNumber ?? "--",
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.neutral2,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                _OrdersHistoryStatusChip(label: order.status ?? ""),
              ],
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            _OrdersHistoryInfoLine(
              icon: Icons.person,
              value: order.customerName,
            ),
            _OrdersHistoryInfoLine(icon: Icons.home_rounded, value: address),
            _OrdersHistoryInfoLine(icon: Icons.payments_rounded, value: cod),
            _OrdersHistoryInfoLine(
              icon: Icons.access_time_filled_rounded,
              value: createdAt,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersHistoryInfoLine extends StatelessWidget {
  const _OrdersHistoryInfoLine({required this.icon, required this.value});

  final IconData icon;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxxSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: AppDimensions.smallIconSize,
            color: AppColors.accentColor1,
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            child: PrimaryText(
              value?.trim().isNotEmpty == true ? value! : "--",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersHistoryStatusChip extends StatelessWidget {
  const _OrdersHistoryStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xSmallSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: AppDimensions.xLargeBorderRadius,
      ),
      child: PrimaryText(
        label.tr(),
        style: AppTextStyles.labelXSmall.copyWith(
          color: Colors.white,
          // fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
