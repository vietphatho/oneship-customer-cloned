import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';

class OrdersHistoryListItem extends StatelessWidget {
  const OrdersHistoryListItem({
    super.key,
    required this.index,
    required this.order,
  });

  final int index;
  final OrderHistoryInfoEntity order;

  @override
  Widget build(BuildContext context) {
    final address = order.fullAddress ?? order.address ?? "--";
    final createdAt = _formatDate(order.createdAt);
    final cod = _formatMoney(order.codAmount ?? 0);
    final statusLabel = switch (order.status) {
      "delivered" => "Đã giao",
      "returned" => "Đã trả",
      _ => order.status ?? "--",
    };

    return Container(
      padding: const EdgeInsets.all(AppDimensions.smallSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.xSmallBorderRadius,
        border: Border.all(color: AppColors.neutral8),
      ),
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
                      TextSpan(text: index.toString().padLeft(2, "0")),
                      const TextSpan(text: " | "),
                      TextSpan(
                        text: order.orderNumber ?? "--",
                        style: const TextStyle(
                          color: AppColors.neutral1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _OrdersHistoryStatusChip(label: statusLabel),
            ],
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          _OrdersHistoryInfoLine(icon: Icons.person, value: order.customerName),
          _OrdersHistoryInfoLine(icon: Icons.home_rounded, value: address),
          _OrdersHistoryInfoLine(icon: Icons.payments_rounded, value: cod),
          _OrdersHistoryInfoLine(
            icon: Icons.access_time_filled_rounded,
            value: createdAt,
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime? value) {
    if (value == null) return "--";

    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, "0");
    final month = local.month.toString().padLeft(2, "0");
    final year = local.year.toString();
    return "$day/$month/$year";
  }

  static String _formatMoney(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return "${buffer}đ";
  }
}

class _OrdersHistoryInfoLine extends StatelessWidget {
  const _OrdersHistoryInfoLine({required this.icon, required this.value});

  final IconData icon;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.smallSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.neutral1),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            child: Text(
              value?.trim().isNotEmpty == true ? value! : "--",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.neutral1,
                fontWeight: FontWeight.w500,
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
        horizontal: AppDimensions.mediumSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.xLargeBorderRadius,
        border: Border.all(color: AppColors.secondary),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.secondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
