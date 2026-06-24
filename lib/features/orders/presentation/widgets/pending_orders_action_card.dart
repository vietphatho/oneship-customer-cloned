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
    this.isSelectionMode = false,
  });

  final int selectedCount;
  final int totalCount;
  final bool isAllSelected;
  final ProcessingOrdersSortOption sortOption;
  final ValueChanged<bool?> onSelectAll;
  final ValueChanged<ProcessingOrdersSortOption?> onSortChanged;
  final VoidCallback onFindShipper;
  final bool isSelectionMode;

  @override
  Widget build(BuildContext context) {
    final effectiveCount = selectedCount > 0 ? selectedCount : totalCount;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.smallSpacing,
        0,
        AppDimensions.smallSpacing,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppDimensions.smallBorderRadius,
              border: Border.all(color: AppColors.neutral8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.smallSpacing),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (isSelectionMode)
                        GestureDetector(
                          onTap: () => onSelectAll(!isAllSelected),
                          child: Row(
                            children: [
                              SizedBox.square(
                                dimension: AppDimensions.mediumIconSize,
                                child: Checkbox(
                                  value: isAllSelected
                                      ? true
                                      : (selectedCount > 0 ? null : false),
                                  tristate: true,
                                  onChanged: onSelectAll,
                                  activeColor: AppColors.primary,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  side: const BorderSide(
                                    color: AppColors.neutral4,
                                    width: AppDimensions.smallBorderStroke,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        AppDimensions.xSmallBorderRadius,
                                  ),
                                ),
                              ),
                              AppSpacing.horizontal(AppDimensions.smallSpacing),
                              PrimaryText(
                                selectedCount > 0
                                    ? 'selected_orders_count'.tr(
                                        namedArgs: {
                                          'count': selectedCount.toString(),
                                        },
                                      )
                                    : '${'select_all'.tr()} ($totalCount)',
                                style: AppTextStyles.labelXSmall.copyWith(
                                  color: AppColors.neutral1,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        PrimaryText(
                          'order_total_count'.tr(
                            namedArgs: {'count': totalCount.toString()},
                          ),
                          style: AppTextStyles.bodyXXSmall.copyWith(
                            color: AppColors.neutral4,
                          ),
                        ),
                      const Spacer(),
                      PrimaryText(
                        '${'sort_label'.tr()}: ',
                        style: AppTextStyles.bodyXXSmall.copyWith(
                          color: AppColors.neutral4,
                        ),
                      ),
                      DropdownButton<ProcessingOrdersSortOption>(
                        value: sortOption,
                        isDense: true,
                        underline: const SizedBox.shrink(),
                        style: AppTextStyles.labelXSmall.copyWith(
                          color: AppColors.neutral2,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: AppDimensions.xSmallIconSize,
                          color: AppColors.neutral4,
                        ),
                        items: ProcessingOrdersSortOption.values.map((opt) {
                          return DropdownMenuItem(
                            value: opt,
                            child: PrimaryText(
                              opt.label,
                              style: AppTextStyles.labelXSmall.copyWith(
                                color: AppColors.neutral2,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: onSortChanged,
                      ),
                    ],
                  ),
                  const Divider(height: AppDimensions.largeSpacing),
                  PrimaryButton.iconFilled(
                    label: 'find_shipper_count'.tr(
                      namedArgs: {'count': effectiveCount.toString()},
                    ),
                    height: AppDimensions.smallHeightButton,
                    icon: const Icon(
                      Icons.person_search_outlined,
                      size: AppDimensions.xSmallIconSize,
                      color: Colors.white,
                    ),
                    onPressed: onFindShipper,
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: AppDimensions.xSmallIconSize,
                color: AppColors.neutral4,
              ),
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              Expanded(
                child: PrimaryText(
                  'find_shipper_empty_selection_hint'.tr(),
                  style: AppTextStyles.bodyXXSmall.copyWith(
                    color: AppColors.neutral4,
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
