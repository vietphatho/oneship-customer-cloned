import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tag.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';

class PackageItem extends StatelessWidget {
  const PackageItem({
    super.key,
    required this.package,
    required this.index,
    this.onViewDetail,
  });

  final int index;
  final Package package;
  final void Function(Package pkg)? onViewDetail;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: () => onViewDetail?.call(package),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppDimensions.largeBorderRadius,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.smallSpacing,
          vertical: AppDimensions.smallSpacing,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      PrimaryText("#${index + 1}. "),
                      PrimaryText(
                        package.packageNumber,
                        style: AppTextStyles.titleMedium,
                      ),
                    ],
                  ),
                ),
                OrderStatusTag(status: package.status ?? ""),
              ],
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            _buildInfoItem(
              label: "total_orders".tr(),
              value: package.totalOrders.toString(),
            ),
            _buildInfoItem(
              label: "total_cod".tr(),
              value: Utils.formatCurrencyWithUnit(package.totalCodAmount),
            ),
            _buildInfoItem(
              label: "total_fee".tr(),
              value: Utils.formatCurrencyWithUnit(package.totalDeliveryFee),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryText("$label: ", style: AppTextStyles.bodyMedium),
        PrimaryText(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
