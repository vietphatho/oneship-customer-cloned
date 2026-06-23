import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tab_bar.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processing_orders_filter_panel.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';

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
  final ShopMasterBloc _shopMasterBloc = getIt.get();

  late List<OrderStatus> _tabList;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabList = const [
      OrderStatus.allProcessing,
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

    var shopId = _shopBloc.state.currentShop?.shopId ?? "";
    _ordersBloc.init(shopId);

    int destination = _tabList.indexOf(OrderStatus.pending);
    _tabCtrl.animateTo(destination);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _ordersBloc.currentOrderStatus = OrderStatus.pending;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'processing_orders_title'.tr(),
        // leading: BackButton(
        //   onPressed: () {
        //     _shopMasterBloc.changeTab(BottomNavigationItem.home);
        //   },
        // ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search, color: AppColors.neutral2),
            tooltip: 'search'.tr(),
            onPressed: () {
              // TODO: implement order search
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: AppColors.neutral2,
            ),
            tooltip: 'filter'.tr(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ProcessingOrdersFilterPanel(
                    initialFilters: _ordersBloc.state.processingOrdersFilters,
                    onApply: (filters) {
                      _ordersBloc.applyProcessingOrdersFilters(filters);
                      Navigator.pop(context);
                    },
                    onReset: () {
                      _ordersBloc.applyProcessingOrdersFilters(
                        ProcessingOrdersFilters.empty(),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PackagesBloc, PackagesState>(
            bloc: _packagesBloc,
            listenWhen: (pre, cur) =>
                pre.findingShipperResult != cur.findingShipperResult,
            listener: _handleFindingShipperChanged,
          ),
          BlocListener<PackagesBloc, PackagesState>(
            bloc: _packagesBloc,
            listenWhen: (pre, cur) =>
                pre.cancelFindingShipperResult !=
                cur.cancelFindingShipperResult,
            listener: _handleCancelFindingShipperChanged,
          ),
          BlocListener<OrdersBloc, OrdersState>(
            bloc: _ordersBloc,
            listenWhen: (previous, current) =>
                previous.orderDetailResource != current.orderDetailResource,
            listener: _listenLoadDetailOrder,
          ),
          BlocListener<PackagesBloc, PackagesState>(
            bloc: _packagesBloc,
            listenWhen: (pre, cur) =>
                pre.findShipperStatus != cur.findShipperStatus,
            listener: _handleFindingShipperStatusListener,
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
                    OrderStatusTabBar(controller: _tabCtrl, items: _tabList),
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
        _tabCtrl.animateTo(destination);
        _packagesBloc.connectSocket();
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
        _tabCtrl.animateTo(destination);
        _packagesBloc.disconnectSocket();
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

  void _handleFindingShipperStatusListener(
    BuildContext context,
    PackagesState state,
  ) {
    switch (state.findShipperStatus) {
      case true:
        PrimaryDialog.showSuccessDialog(
          context,
          message: "shipper_founded".tr(),
          onClosed: () {
            int destination = _tabList.indexOf(OrderStatus.batched);
            _tabCtrl.animateTo(destination);
          },
        );
        break;
      case false:
        PrimaryDialog.showErrorDialog(
          context,
          title: "not_found".tr(),
          message: "shipper_not_found".tr(),
        );
        break;
      default:
        break;
    }
  }
}
