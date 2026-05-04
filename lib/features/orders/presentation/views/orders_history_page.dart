import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_app_bar.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_content.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_tab_bar.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class OrdersHistoryPage extends StatefulWidget {
  const OrdersHistoryPage({super.key});

  @override
  State<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage>
    with SingleTickerProviderStateMixin {
  final OrdersBloc _ordersBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  late final TabController _tabController;

  final List<OrderStatus> _tabs = const [
    OrderStatus.delivered,
    OrderStatus.returned,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    final shopId = _shopBloc.state.currentShop?.shopId ?? "";
    _ordersBloc.shopId = shopId;
    _ordersBloc.fetchArchivedOrders(OrderStatus.delivered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OrdersHistoryAppBar(
        onBack: _goToPreviousTabOrBack,
        onNext: _goToNextTab,
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          builder: (context, state) {
            return Column(
              children: [
                OrdersHistoryTabBar(
                  controller: _tabController,
                  deliveredCount:
                      _ordersBloc.filteredDeliveredArchivedOrdersList.length,
                  returnedCount:
                      _ordersBloc.filteredReturnedArchivedOrdersList.length,
                  onTap: _onTabChanged,
                ),
                Expanded(
                  child: OrdersHistoryContent(
                    controller: _tabController,
                    ordersBloc: _ordersBloc,
                    state: state,
                    isLoadingFor: _isLoadingFor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isLoadingFor(OrderStatus status, OrdersState state) {
    if (state.orderListByStatusResource.state != Result.loading) {
      return false;
    }

    return _tabs[_tabController.index] == status;
  }

  void _onTabChanged(int index) {
    _ordersBloc.fetchArchivedOrders(_tabs[index]);
  }

  void _goToNextTab() {
    final nextIndex = (_tabController.index + 1).clamp(0, _tabs.length - 1);
    if (nextIndex == _tabController.index) return;

    _tabController.animateTo(nextIndex);
    _onTabChanged(nextIndex);
  }

  void _goToPreviousTabOrBack() {
    final previousIndex = _tabController.index - 1;
    if (previousIndex < 0) {
      Navigator.of(context).maybePop();
      return;
    }

    _tabController.animateTo(previousIndex);
    _onTabChanged(previousIndex);
  }
}
