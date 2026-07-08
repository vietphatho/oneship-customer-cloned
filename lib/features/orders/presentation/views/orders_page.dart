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
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  static const List<OrderStatus> _baseTabs = [
    OrderStatus.pending,
    OrderStatus.processing,
    OrderStatus.batched,
    OrderStatus.shipping,
    OrderStatus.atHub,
    OrderStatus.delayed,
    OrderStatus.cancelled,
    OrderStatus.returned,
  ];

  final OrdersBloc _ordersBloc = getIt.get();
  final PackagesBloc _packagesBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  late List<OrderStatus> _tabList;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabList = _visibleTabsForShopType(_shopBloc.state.currentShop?.shopType);

    var shopId = _shopBloc.state.currentShop?.shopId ?? "";
    _ordersBloc.init(shopId);

    _tabCtrl = TabController(
      length: _tabList.length,
      vsync: this,
      initialIndex: _tabIndexOf(OrderStatus.pending),
    );
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
      // backgroundColor: AppColors.neutral9,
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.largeRadius),
                  ),
                ),
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    top: AppDimensions.mediumSpacing,
                    bottom:
                        AppDimensions.xLargeSpacing +
                        MediaQuery.of(context).viewInsets.bottom,
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
          BlocListener<ShopBloc, ShopState>(
            bloc: _shopBloc,
            listenWhen: (previous, current) =>
                previous.currentShop?.shopId != current.currentShop?.shopId ||
                previous.currentShop?.shopType != current.currentShop?.shopType,
            listener: _handleCurrentShopChanged,
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
                    AppSpacing.vertical(
                      MediaQuery.of(context).padding.bottom +
                          AppDimensions.largeSpacing,
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
        _animateToStatus(OrderStatus.processing);
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
        _animateToStatus(OrderStatus.pending);
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
            _animateToStatus(OrderStatus.batched);
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

  void _handleCurrentShopChanged(BuildContext context, ShopState state) {
    _ordersBloc.init(state.currentShop?.shopId ?? "");
    final selectedStatus = _updateVisibleTabs(state.currentShop?.shopType);
    _ordersBloc.currentOrderStatus = selectedStatus;
    _ordersBloc.fetchOrdersByStatus();
  }

  OrderStatus _updateVisibleTabs(ShopType? shopType) {
    final nextTabs = _visibleTabsForShopType(shopType);
    if (const ListEquality<OrderStatus>().equals(_tabList, nextTabs)) {
      return _tabList[_tabCtrl.index];
    }

    final selectedStatus = _tabList[_tabCtrl.index];
    final nextSelectedStatus = nextTabs.contains(selectedStatus)
        ? selectedStatus
        : OrderStatus.pending;
    final nextIndex = nextTabs.indexOf(nextSelectedStatus);

    final previousController = _tabCtrl;
    setState(() {
      _tabList = nextTabs;
      _tabCtrl = TabController(
        length: _tabList.length,
        vsync: this,
        initialIndex: nextIndex < 0 ? 0 : nextIndex,
      );
    });
    previousController.dispose();
    return nextSelectedStatus;
  }

  List<OrderStatus> _visibleTabsForShopType(ShopType? shopType) {
    if (shopType == ShopType.hospital) {
      return const [OrderStatus.created, ..._baseTabs];
    }
    return _baseTabs;
  }

  int _tabIndexOf(OrderStatus status) {
    final index = _tabList.indexOf(status);
    return index < 0 ? 0 : index;
  }

  void _animateToStatus(OrderStatus status) {
    final index = _tabList.indexOf(status);
    if (index < 0 || index >= _tabCtrl.length) return;
    _tabCtrl.animateTo(index);
  }
}
