import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/customer/home/data/enum.dart';
import 'package:oneship_customer/features/customer/home/presentation/widgets/customer_app_bar.dart';
import 'package:oneship_customer/features/customer/home/presentation/widgets/customer_ord_tab_bar.dart';
import 'package:oneship_customer/features/customer/home/presentation/widgets/customer_order_tracking_input_session.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: CustomerOrdTab.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(gradient: AppColors.shopHomeGradBg),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomerAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                const CustomerOrderTrackingInputSession(),
                CustomerOrdTabBar(tabController: _tabCtrl),
                // Expanded(child: TabBarView(children: )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
