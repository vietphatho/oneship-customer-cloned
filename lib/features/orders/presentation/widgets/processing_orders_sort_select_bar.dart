import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';

/// Sort options for the processing orders list.
enum ProcessingOrdersSortOption {
  newest,
  oldest,
  codHighest,
  codLowest,
}

extension ProcessingOrdersSortOptionExt on ProcessingOrdersSortOption {
  String get label {
    switch (this) {
      case ProcessingOrdersSortOption.newest:
        return 'sort_newest'.tr();
      case ProcessingOrdersSortOption.oldest:
        return 'sort_oldest'.tr();
      case ProcessingOrdersSortOption.codHighest:
        return 'sort_cod_highest'.tr();
      case ProcessingOrdersSortOption.codLowest:
        return 'sort_cod_lowest'.tr();
    }
  }
}

/// Bar showing "Chọn tất cả (N)" checkbox + "Sắp xếp: ..." dropdown.
class ProcessingOrdersSortSelectBar extends StatelessWidget {
  const ProcessingOrdersSortSelectBar({
    super.key,
    required this.totalCount,
    required this.selectedCount,
    required this.isAllSelected,
    required this.sortOption,
    required this.onSelectAll,
    required this.onSortChanged,
  });

  final int totalCount;
  final int selectedCount;
  final bool isAllSelected;
  final ProcessingOrdersSortOption sortOption;
  final ValueChanged<bool?> onSelectAll;
  final ValueChanged<ProcessingOrdersSortOption?> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onSelectAll(!isAllSelected),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: isAllSelected,
                    tristate: selectedCount > 0 && !isAllSelected,
                    onChanged: onSelectAll,
                    activeColor: AppColors.secondary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                AppSpacing.horizontal(6),
                PrimaryText(
                  '${'select_all'.tr()} ($totalCount)',
                  style: AppTextStyles.labelXSmall.copyWith(
                    color: AppColors.neutral2,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          PrimaryText(
            '${'sort_label'.tr()}: ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.neutral4,
              fontSize: 12,
            ),
          ),
          DropdownButton<ProcessingOrdersSortOption>(
            value: sortOption,
            isDense: true,
            underline: const SizedBox.shrink(),
            style: AppTextStyles.labelXSmall.copyWith(
              color: AppColors.neutral2,
              fontSize: 12,
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.neutral4,
            ),
            items: ProcessingOrdersSortOption.values.map((opt) {
              return DropdownMenuItem(
                value: opt,
                child: PrimaryText(
                  opt.label,
                  style: AppTextStyles.labelXSmall.copyWith(
                    color: AppColors.neutral2,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
            onChanged: onSortChanged,
          ),
        ],
      ),
    );
  }
}
/// Sort helper - sorts a list of [OrderInfo] by the given [ProcessingOrdersSortOption].
List<OrderInfo> sortOrders(
  List<OrderInfo> orders,
  ProcessingOrdersSortOption option,
) {
  final sorted = List<OrderInfo>.from(orders);
  switch (option) {
    case ProcessingOrdersSortOption.newest:
      sorted.sort(
        (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
          a.createdAt ?? DateTime(0),
        ),
      );
      break;
    case ProcessingOrdersSortOption.oldest:
      sorted.sort(
        (a, b) => (a.createdAt ?? DateTime(0)).compareTo(
          b.createdAt ?? DateTime(0),
        ),
      );
      break;
    case ProcessingOrdersSortOption.codHighest:
      sorted.sort((a, b) => (b.codAmount ?? 0).compareTo(a.codAmount ?? 0));
      break;
    case ProcessingOrdersSortOption.codLowest:
      sorted.sort((a, b) => (a.codAmount ?? 0).compareTo(b.codAmount ?? 0));
      break;
  }
  return sorted;
}
