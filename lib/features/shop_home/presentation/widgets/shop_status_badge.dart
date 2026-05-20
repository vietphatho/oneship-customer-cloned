import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';

class ShopStatusBadge extends StatelessWidget {
  final ShopStatus status;

  const ShopStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // final status = status?.toLowerCase() ?? '';
    // final bool isActive = status == 'active';
    // final bool isPending = status == 'pending';

    // final Color bgColor;
    // final Color textColor;
    // final String label;

    // if (isActive) {
    //   bgColor = const Color(0xFFE8F5E9);
    //   textColor = const Color(0xFF2E7D32);
    //   label = 'shop_management.status_active'.tr();
    // } else if (isPending) {
    //   bgColor = const Color(0xFFFFF3E0);
    //   textColor = const Color(0xFFE65100);
    //   label = 'shop_management.status_pending'.tr();
    // } else {
    //   bgColor = const Color(0xFFEEEEEE);
    //   textColor = AppColors.neutral4;
    //   label = 'shop_management.status_inactive'.tr();
    // }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentColor1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: PrimaryText(
        status.name,
        style: AppTextStyles.labelXSmall,
        color: Colors.white,
      ),
    );
  }
}
