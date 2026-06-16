import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_content.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_tab_bar.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processing_orders_filter_panel.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_master/presentation/widgets/primary_bottom_navigation_bar.dart';

class OrdersHistoryPage extends StatefulWidget {
  const OrdersHistoryPage({super.key});

  @override
  State<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage>
    with SingleTickerProviderStateMixin {
  final OrdersBloc _ordersBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  final ShopMasterBloc _shopMasterBloc = getIt.get();

  late List<OrderStatus> _tabList;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabList = const [OrderStatus.allProcessing, OrderStatus.delivered, OrderStatus.returned];
    _tabCtrl = TabController(length: _tabList.length, vsync: this);

    final shopId = _shopBloc.state.currentShop?.shopId ?? "";
    _ordersBloc.shopId = shopId;
    _ordersBloc.fetchOrderHistory(OrderStatus.allProcessing);
    _ordersBloc.fetchOrderHistory(OrderStatus.delivered);
    _ordersBloc.fetchOrderHistory(OrderStatus.returned);

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
      extendBody: true,
      bottomNavigationBar: const PrimaryBottomNavigationBar(),
      appBar: PrimaryAppBar(
        title: "completed_orders".tr(),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search, color: AppColors.neutral2),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: AppColors.neutral2),
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
                      _ordersBloc.applyProcessingOrdersFilters(ProcessingOrdersFilters.empty());
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
          BlocListener<ShopMasterBloc, ShopMasterState>(
            bloc: _shopMasterBloc,
            listenWhen: (previous, current) => current is ShopMasterMenuTabChangedState,
            listener: (context, state) {
              if (state is ShopMasterMenuTabChangedState) {
                context.go(RouteName.shopMasterPage);
              }
            },
          ),
          BlocListener<OrdersBloc, OrdersState>(
            bloc: _ordersBloc,
            listenWhen: (previous, current) =>
                previous.orderDetailResource != current.orderDetailResource,
            listener: _listenLoadDetailOrder,
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: _tabList.length,
                child: Column(
                  children: [
                    OrdersHistoryTabBar(
                      controller: _tabCtrl,
                      onTap: _onTabChanged,
                    ),
                    
                    AnimatedBuilder(
                      animation: _tabCtrl,
                      builder: (context, _) {
                        return BlocBuilder<OrdersBloc, OrdersState>(
                          bloc: _ordersBloc,
                          builder: (context, state) {
                            final currentStatus = _tabList[_tabCtrl.index];
                            final totalCount = state.getHistoryOrdersCountForStatus(currentStatus);

                            return Padding(
                              padding: const EdgeInsets.only(
                                left: AppDimensions.largeSpacing,
                                right: AppDimensions.largeSpacing,
                                top: AppDimensions.mediumSpacing,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: PrimaryText(
                                  "Danh sách đơn hàng ($totalCount)",
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.neutral1,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: OrdersHistoryContent(
                        controller: _tabCtrl,
                        isLoadingFor: _isLoadingFor,
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

  bool _isLoadingFor(OrderStatus status, OrdersState state) {
    if (state.ordersHistoryResource.state != Result.loading) {
      return false;
    }

    return _tabList[_tabCtrl.index] == status;
  }

  void _onTabChanged(int index) {
    _ordersBloc.fetchOrderHistory(_tabList[index]);
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
