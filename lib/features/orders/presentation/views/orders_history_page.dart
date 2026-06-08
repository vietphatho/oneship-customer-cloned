import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_state.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_content.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_tab_bar.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processed_orders_summary_card.dart';
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

  final FinanceOverviewBloc _financeBloc = getIt.get();
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

    final now = DateTime.now();
    _financeBloc.fetchFinancialData(
      filter: FinanceFilter.thirtyDay,
      startDate: DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30)),
      endDate: DateTime(now.year, now.month, now.day),
      shopId: shopId,
      requestSource: FinanceRequestSource.page,
    );
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
              _ordersBloc.toggleOrdersHistoryFilters();
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
          BlocListener<FinanceOverviewBloc, FinanceOverviewState>(
            bloc: _financeBloc,
            listenWhen: (previous, current) =>
                previous.shopFinancialData.state != current.shopFinancialData.state,
            listener: (context, state) {
              if (state.shopFinancialData.state == Result.error) {
                PrimaryDialog.showErrorDialog(
                  context,
                  message: "Lỗi tải doanh thu: ${state.shopFinancialData.message}",
                );
              }
            },
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
                    
                    BlocBuilder<OrdersBloc, OrdersState>(
                      bloc: _ordersBloc,
                      builder: (context, ordersState) {
                        return BlocBuilder<FinanceOverviewBloc, FinanceOverviewState>(
                          bloc: _financeBloc,
                          builder: (context, financeState) {
                            final data = financeState.shopFinancialData.data;
                            final meta = ordersState.ordersHistoryResource.data?.meta;
                            return ProcessedOrdersSummaryCard(
                              totalOrders: meta?.total ?? 0,
                              revenue: data?.netAmount ?? 0,
                              returnedAmount: data?.totalOut ?? 0,
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppDimensions.largeSpacing,
                        right: AppDimensions.largeSpacing,
                        top: AppDimensions.mediumSpacing,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: PrimaryText(
                          "Danh sách đơn hàng",
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.neutral1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
