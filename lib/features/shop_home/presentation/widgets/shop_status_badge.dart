import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/features/shop_home/data/enum.dart';

class ShopStatusBadge extends StatelessWidget {
  final ShopStatus status;

  const ShopStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: status.bgColor,
      ),
      child: PrimaryText(
        status.label,
        style: AppTextStyles.labelXSmall,
        color: AppColors.neutral2,
      ),
    );
  }
}
