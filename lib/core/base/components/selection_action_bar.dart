import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';

/// A reusable selection action bar for list screens with multi-select support.
///
/// Shows:
/// - A tristate checkbox for select-all / deselect
/// - A label that dynamically shows selected count or total count
/// - A primary action button (e.g. "Tìm shipper", "Xoá", v.v.)
/// - An optional hint text below the divider
///
/// Example usage:
/// ```dart
/// SelectionActionBar(
///   selectedCount: _selected.length,
///   totalCount: _orders.length,
///   isAllSelected: _selected.length == _orders.length,
///   selectedLabel: (n) => 'Đã chọn $n đơn',
///   totalLabel: (n) => 'Chọn tất cả ($n)',
///   actionLabel: (n) => 'Tìm shipper ($n)',
///   actionIcon: Icons.person_search_outlined,
///   onSelectAll: (val) { ... },
///   onDeselect: () { ... },
///   onAction: () { ... },
///   hintText: 'Không chọn đơn nào để tìm shipper cho tất cả.',
/// )
/// ```
class SelectionActionBar extends StatelessWidget {
  const SelectionActionBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.isAllSelected,
    required this.onSelectAll,
    required this.onDeselect,
    required this.onAction,
    required this.actionLabel,
    required this.actionIcon,
    this.selectedLabel,
    this.totalLabel,
    this.hintText,
    this.actionColor,
  });

  /// Số lượng item đang được chọn
  final int selectedCount;

  /// Tổng số item trong danh sách
  final int totalCount;

  /// True nếu tất cả đã được chọn
  final bool isAllSelected;

  /// Callback khi nhấn checkbox select-all (val=true) hoặc select-none (val=false)
  final ValueChanged<bool?> onSelectAll;

  /// Callback khi bỏ chọn tất cả
  final VoidCallback onDeselect;

  /// Callback khi nhấn nút hành động chính
  final VoidCallback onAction;

  /// Builder nhãn khi đang có đơn được chọn, e.g. "Đã chọn 3 đơn"
  final String Function(int count)? selectedLabel;

  /// Builder nhãn khi chưa chọn gì, e.g. "Chọn tất cả (10)"
  final String Function(int total)? totalLabel;

  /// Builder nhãn cho nút action chính, nhận số count thực tế (selected hoặc total)
  final String Function(int count) actionLabel;

  /// Icon cho nút action chính
  final IconData actionIcon;

  /// Gợi ý hiển thị dưới đường kẻ
  final String? hintText;

  /// Màu nền của nút action (mặc định là AppColors.secondary)
  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    final effectiveCount = selectedCount > 0 ? selectedCount : totalCount;

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
              // Checkbox select-all (tristate)
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isAllSelected
                      ? true
                      : (selectedCount > 0 ? null : false),
                  tristate: true,
                  onChanged: (val) {
                    if (val == null) {
                      onDeselect();
                    } else {
                      onSelectAll(val);
                    }
                  },
                  activeColor: AppColors.primary,
                  side:
                      const BorderSide(color: AppColors.neutral4, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.smallSpacing),

              // Label động
              Expanded(
                child: Text(
                  selectedCount > 0
                      ? (selectedLabel?.call(selectedCount) ??
                          'Đã chọn $selectedCount')
                      : (totalLabel?.call(totalCount) ??
                          'Chọn tất cả ($totalCount)'),
                  overflow: TextOverflow.ellipsis,
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
              ),
              const SizedBox(width: AppDimensions.xSmallSpacing),

              // Nút action chính
              SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: onAction,
                  icon: Icon(
                    actionIcon,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(
                    actionLabel(effectiveCount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionColor ?? AppColors.secondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.smallSpacing,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Hint text (tùy chọn)
          if (hintText != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(height: 1, color: AppColors.neutral6),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.neutral4,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    hintText!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
