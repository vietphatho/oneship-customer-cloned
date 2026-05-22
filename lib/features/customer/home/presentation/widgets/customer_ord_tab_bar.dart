import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_tab_bar.dart';
import 'package:oneship_customer/features/customer/home/data/enum.dart';

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
