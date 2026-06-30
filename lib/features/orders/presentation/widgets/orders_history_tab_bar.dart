import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_tab_bar.dart';

class OrdersHistoryTabBar extends StatelessWidget {
  const OrdersHistoryTabBar({
    super.key,
    required this.controller,
    required this.onTap,
  });

  final TabController controller;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
      ),
      child: PrimaryTabBar(
        controller: controller,
        onTap: onTap,
        items: ["all".tr(), "delivered".tr(), "returned".tr()],
      ),
    );
  }
}
