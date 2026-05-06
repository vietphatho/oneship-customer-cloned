import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_tab_bar.dart';

class OrdersHistoryTabBar extends StatelessWidget {
  const OrdersHistoryTabBar({
    super.key,
    required this.controller,
    required this.deliveredCount,
    required this.returnedCount,
    required this.onTap,
  });

  final TabController controller;
  final int deliveredCount;
  final int returnedCount;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.largeSpacing,
      ),
      child: PrimaryTabBar(
        controller: controller,
        onTap: onTap,
        items: const ["Đã giao hàng", "Đã trả hàng"],
      ),
    );
  }
}
