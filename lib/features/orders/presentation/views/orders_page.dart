import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_dialog.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/core/navigation/route_name.dart';
import 'package:oneship_shop/di/injection_container.dart';
import 'package:oneship_shop/features/orders/data/enum.dart';
import 'package:oneship_shop/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_shop/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_shop/features/orders/presentation/widgets/order_status_tab_bar.dart';
import 'package:oneship_shop/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_shop/features/packages/presentation/bloc/packages_state.dart';
import 'package:oneship_shop/features/shop_home/presentation/bloc/shop_bloc.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  final OrdersBloc _ordersBloc = getIt.get();
  final PackagesBloc _packagesBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  late List<OrderStatus> _tabList;
  late TabController _tabCtrl;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabList = const [
      OrderStatus.atHub,
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.batched,
      OrderStatus.shipping,
      OrderStatus.delayed,
      OrderStatus.cancelled,
      OrderStatus.returned,
    ];
    _tabCtrl = TabController(length: _tabList.length, vsync: this);
    _tabCtrl.addListener(_tabListener);

    var shopId = _shopBloc.state.currentShop?.shopId ?? "";
    _ordersBloc.init(shopId);
  }

  @override
  void dispose() {
    _tabCtrl.removeListener(_tabListener);
    _tabCtrl.dispose();
    _ordersBloc.currentOrderStatus = OrderStatus.pending;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "orders".tr()),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PackagesBloc, PackagesState>(
            bloc: _packagesBloc,
            listenWhen:
                (pre, cur) =>
                    pre.findingShipperResult != cur.findingShipperResult,
            listener: _handleFindingShipperChanged,
          ),
          BlocListener<PackagesBloc, PackagesState>(
            bloc: _packagesBloc,
            listenWhen:
                (pre, cur) =>
                    pre.cancelFindingShipperResult !=
                    cur.cancelFindingShipperResult,
            listener: _handleCancelFindingShipperChanged,
          ),
          BlocListener<OrdersBloc, OrdersState>(
            bloc: _ordersBloc,
            listenWhen:
                (previous, current) =>
                    previous.orderDetailResource != current.orderDetailResource,
            listener: _listenLoadDetailOrder,
          ),
        ],
        child: Column(
          children: [
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(
            //       AppDimensions.mediumSpacing,
            //       0,
            //       0,
            //       AppDimensions.xSmallSpacing,
            //     ),
            //     child: const ShopSelectionButton(),
            //   ),
            // ),
            Expanded(
              child: DefaultTabController(
                length: _tabList.length,
                child: Column(
                  children: [
                    OrderStatusTabBar(
                      controller: _tabCtrl,
                      items: _tabList,
                      onTap: _onTabChanged,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabCtrl,
                        children: _tabList.map((e) => e.view).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFindingShipperChanged(
    BuildContext context,
    PackagesState state,
  ) async {
    switch (state.findingShipperResult.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        await Future.delayed(Durations.short2);
        int destination = _tabList.indexOf(OrderStatus.processing);
        _onTabChanged(destination);
        _tabCtrl.animateTo(destination);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.currentPkg.message,
        );
        break;
    }
  }

  void _handleCancelFindingShipperChanged(
    BuildContext context,
    PackagesState state,
  ) async {
    switch (state.cancelFindingShipperResult.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        await Future.delayed(Durations.short2);
        int destination = _tabList.indexOf(OrderStatus.pending);
        _onTabChanged(destination);
        _tabCtrl.animateTo(destination);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.currentPkg.message,
        );
        break;
    }
  }

  void _onTabChanged(int tabIndex) {
    if (_previousIndex == tabIndex) return;
    _previousIndex = tabIndex;
    _ordersBloc.currentOrderStatus = _tabList[tabIndex];
  }

  void _tabListener() {
    _onTabChanged(_tabCtrl.index);
  }

  void _listenLoadDetailOrder(BuildContext context, OrdersState state) {
    switch (state.orderDetailResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        context.push(RouteName.orderDetailPage);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.orderDetailResource.message,
        );
    }
  }
}
