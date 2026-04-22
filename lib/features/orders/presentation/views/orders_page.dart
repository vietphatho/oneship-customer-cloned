import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/management/presentation/bloc/management_bloc.dart';
import 'package:oneship_customer/features/management/presentation/bloc/management_state.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tab_bar.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  final OrdersBloc _ordersBloc = getIt.get();
  final ManagementBloc _managementBloc = getIt.get();
  final PackagesBloc _packagesBloc = getIt.get();

  late List<OrderStatus> _tabList;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabList = const [
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.batched,
      OrderStatus.shipping,
      OrderStatus.delayed,
      OrderStatus.cancelled,
      OrderStatus.returned,
    ];
    _tabCtrl = TabController(length: _tabList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BlocListener<ManagementBloc, ManagementState>(
            bloc: _managementBloc,
            listener: _handleListener,
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

  void _handleListener(BuildContext context, ManagementState state) {
    if (state is ManagementGetShopsState &&
        state.resource.state == Result.success &&
        _managementBloc.currentShop != null) {
      String shopId = _managementBloc.currentShop?.shopId ?? "";
      _ordersBloc.init(shopId);
      _packagesBloc.init(shopId);
    }
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
    _ordersBloc.currentOrderStatus = _tabList[tabIndex];
  }
}
