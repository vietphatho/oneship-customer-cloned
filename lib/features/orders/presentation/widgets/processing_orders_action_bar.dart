import 'package:oneship_customer/core/base/base_import_components.dart';

/// Action bar shown when one or more orders are selected.
/// Displays: "Đã chọn {N} đơn" + "Bỏ chọn" | "Tìm shipper (N)"
class ProcessingOrdersActionBar extends StatelessWidget {
  const ProcessingOrdersActionBar({
    super.key,
    required this.selectedCount,
    required this.onDeselect,
    required this.onFindShipper,
  });

  final int selectedCount;
  final VoidCallback onDeselect;
  final VoidCallback onFindShipper;

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) return const SizedBox.shrink();

    return Container(
      color: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.xSmallSpacing,
      ),
      child: Row(
        children: [
          // Checkbox icon
          const Icon(
            Icons.check_box_rounded,
            size: AppDimensions.smallIconSize,
            color: AppColors.secondary,
          ),
          const SizedBox(width: AppDimensions.xxSmallSpacing),
          // Count text
          Expanded(
            child: Text(
              'selected_orders_count'.tr(
                namedArgs: {'count': selectedCount.toString()},
              ),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral2,
              ),
            ),
          ),
          // Bỏ chọn button
          TextButton(
            onPressed: onDeselect,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xSmallSpacing,
                vertical: AppDimensions.xxSmallSpacing,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColors.neutral4,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Text('deselect'.tr()),
          ),
          const SizedBox(width: AppDimensions.xxSmallSpacing),
          // Tìm shipper button
          SizedBox(
            height: 32,
            child: ElevatedButton.icon(
              onPressed: onFindShipper,
              icon: const Icon(
                Icons.gps_fixed_outlined,
                size: AppDimensions.xSmallIconSize,
                color: Colors.white,
              ),
              label: Text(
                'find_shipper_count'.tr(
                  namedArgs: {'count': selectedCount.toString()},
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.xSmallBorderRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.xSmallSpacing,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
