import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_tab_bar.dart';
import 'package:oneship_shop/features/customer/home/data/enum.dart';

class CustomerOrdTabBar extends StatelessWidget {
  const CustomerOrdTabBar({super.key, required this.tabController, this.onTap});

  final TabController tabController;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return PrimaryTabBar(
      items: CustomerOrdTab.values.map((e) => e.statusName.tr()).toList(),
      controller: tabController,
      onTap: onTap,
    );
  }
}
