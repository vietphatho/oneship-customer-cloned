import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
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

  late List<OrderStatus> _tabList;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabList = const [OrderStatus.delivered, OrderStatus.returned];
    _tabCtrl = TabController(length: _tabList.length, vsync: this);

    final shopId = _shopBloc.state.currentShop?.shopId ?? "";
    _ordersBloc.shopId = shopId;
    _ordersBloc.fetchOrderHistory(OrderStatus.delivered);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PrimaryAppBar(title: "Đơn hàng đã xử lý"),
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: _tabList.length,
              child: BlocBuilder<OrdersBloc, OrdersState>(
                bloc: _ordersBloc,
                builder: (context, state) {
                  return Column(
                    children: [
                      OrdersHistoryTabBar(
                        controller: _tabCtrl,
                        deliveredCount:
                            state.filteredDeliveredOrdersHistoryList.length,
                        returnedCount:
                            state.filteredReturnedOrdersHistoryList.length,
                        onTap: _onTabChanged,
                      ),
                      Expanded(
                        child: OrdersHistoryContent(
                          controller: _tabCtrl,
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
          ),
        ],
      ),
    );
  }

  bool _isLoadingFor(OrderStatus status, OrdersState state) {
    if (state.ordersHistoryResource.state != Result.loading) {
      return false;
    }

    return _tabList[_tabCtrl.index] == status;
  }

  void _onTabChanged(int index) {
    _ordersBloc.fetchOrderHistory(_tabList[index]);
  }
}
