import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processing_orders_sort_select_bar.dart';

class PendingOrdersActionCard extends StatelessWidget {
  const PendingOrdersActionCard({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.isAllSelected,
    required this.sortOption,
    required this.onSelectAll,
    required this.onSortChanged,
    required this.onFindShipper,
  });

  final int selectedCount;
  final int totalCount;
  final bool isAllSelected;
  final ProcessingOrdersSortOption sortOption;
  final ValueChanged<bool?> onSelectAll;
  final ValueChanged<ProcessingOrdersSortOption?> onSortChanged;
  final VoidCallback onFindShipper;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.smallSpacing,
        AppDimensions.smallSpacing,
        AppDimensions.smallSpacing,
        0,
      ),
      padding: const EdgeInsets.all(AppDimensions.smallSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.smallBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => onSelectAll(!isAllSelected),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isAllSelected
                            ? true
                            : (selectedCount > 0 ? null : false),
                        tristate: true,
                        onChanged: onSelectAll,
                        activeColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.neutral4, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.smallSpacing),
                    Text(
                      selectedCount > 0
                          ? 'Đã chọn $selectedCount đơn'
                          : 'Chọn tất cả ($totalCount)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selectedCount > 0
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: selectedCount > 0
                            ? AppColors.neutral1
                            : AppColors.neutral2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${'sort_label'.tr()}: ',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.neutral4,
                ),
              ),
              DropdownButton<ProcessingOrdersSortOption>(
                value: sortOption,
                isDense: true,
                underline: const SizedBox.shrink(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.neutral2,
                  fontWeight: FontWeight.w600,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.neutral4,
                ),
                items: ProcessingOrdersSortOption.values.map((opt) {
                  return DropdownMenuItem(
                    value: opt,
                    child: Text(opt.label),
                  );
                }).toList(),
                onChanged: onSortChanged,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, color: AppColors.neutral6),
          ),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton.icon(
              onPressed: onFindShipper,
              icon: const Icon(
                Icons.person_search_outlined,
                size: 18,
                color: Colors.white,
              ),
              label: Text(
                'Tìm shipper (${selectedCount > 0 ? selectedCount : totalCount})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.smallSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.neutral4,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Không chọn đơn nào để tìm shipper cho tất cả đơn hàng.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.neutral3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
