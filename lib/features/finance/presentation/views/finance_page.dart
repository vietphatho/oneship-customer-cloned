import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/finance/data/enum.dart';
import 'package:oneship_customer/features/finance/presentation/views/finance_overview_tab_view.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_tab_bar.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "finance".tr(), canPop: false),
      body: SafeArea(
        child: DefaultTabController(
          length: FinanceSubFeature.values.length,
          child: Column(
            children: [
              FinanceTabBar(controller: controller),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  children: [FinanceOverviewTabView(), Container()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
