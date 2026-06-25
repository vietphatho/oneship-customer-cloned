import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_tab_bar.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/widgets/vendor_orders_tab_body.dart';

class VendorOrdersSection extends StatefulWidget {
  const VendorOrdersSection({super.key});

  @override
  State<VendorOrdersSection> createState() => _VendorOrdersSectionState();
}

class _VendorOrdersSectionState extends State<VendorOrdersSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _VendorOrdersTabBar(controller: _tabController),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        Expanded(
          child: IndexedStack(
            index: _tabController.index,
            children: const [
              VendorOrdersTabBody(tab: VendorOrdersTab.processing),
              VendorOrdersTabBody(tab: VendorOrdersTab.archived),
            ],
          ),
        ),
      ],
    );
  }
}

class _VendorOrdersTabBar extends StatelessWidget {
  const _VendorOrdersTabBar({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return PrimaryTabBar(
      controller: controller,
      height: AppDimensions.mediumHeightButton,
      borderRadius: AppDimensions.largeBorderRadius,
      items: [
        'vendor_home.orders.processing_tab'.tr(),
        'vendor_home.orders.archived_tab'.tr(),
      ],
    );
  }
}
