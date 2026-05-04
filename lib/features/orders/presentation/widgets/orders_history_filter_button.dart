import 'package:oneship_customer/core/base/base_import_components.dart';

class OrdersHistoryFilterButton extends StatelessWidget {
  const OrdersHistoryFilterButton({
    super.key,
    required this.onTap,
    this.isExpanded = false,
  });

  final VoidCallback onTap;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondary,
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(Icons.filter_alt, size: 15),
      label: Text(
        isExpanded ? "Ẩn bộ lọc" : "Hiện bộ lọc",
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.secondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
