import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class PrimaryPagination extends StatelessWidget {
  const PrimaryPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (totalItems == 0) return const SizedBox.shrink();

    final startItem = (currentPage - 1) * itemsPerPage + 1;
    final endItem = (startItem + itemsPerPage - 1).clamp(1, totalItems);

    return Column(
      children: [
        PrimaryText(
          'Hiển thị $startItem - $endItem trong tổng số $totalItems khiếu nại',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPageButton(
              icon: Icons.chevron_left,
              onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            ),
            const SizedBox(width: 8),
            ..._buildPageNumbers(),
            const SizedBox(width: 8),
            _buildPageButton(
              icon: Icons.chevron_right,
              onTap: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    final List<Widget> buttons = [];
    final int startPage = (currentPage - 2).clamp(1, totalPages);
    final int endPage = (currentPage + 2).clamp(1, totalPages);

    for (int i = startPage; i <= endPage; i++) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _buildPageButton(
            text: i.toString(),
            isSelected: i == currentPage,
            onTap: () => onPageChanged(i),
          ),
        ),
      );
    }
    return buttons;
  }

  Widget _buildPageButton({
    IconData? icon,
    String? text,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
          ),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(
                icon,
                size: 18,
                color: onTap == null ? AppColors.grey300 : AppColors.grey600,
              )
            : PrimaryText(
                text ?? '',
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.grey600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
      ),
    );
  }
}
