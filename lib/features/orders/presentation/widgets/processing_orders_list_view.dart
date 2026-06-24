import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/finding_shipper_search_widget.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processing_orders_sort_select_bar.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ProcessingOrdersListView extends StatefulWidget {
  const ProcessingOrdersListView({super.key});

  @override
  State<ProcessingOrdersListView> createState() =>
      _ProcessingOrdersListViewState();
}

class _ProcessingOrdersListViewState extends State<ProcessingOrdersListView> {
  final OrdersBloc _ordersBloc = getIt.get();
  final RefreshController _refreshController = RefreshController();

  // Selection & Sorting state
  final Set<String> _selectedOrderKeys = {};
  ProcessingOrdersSortOption _sortOption = ProcessingOrdersSortOption.newest;

  @override
  void initState() {
    super.initState();
    _ordersBloc.currentOrderStatus = OrderStatus.processing;
    _ordersBloc.fetchOrdersByStatus();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          listenWhen: (previous, current) =>
              previous.processingOrdersList != current.processingOrdersList,
          listener: _listenOrdsListChanged,
        ),
      ],
      child: BlocBuilder<OrdersBloc, OrdersState>(
        bloc: _ordersBloc,
        buildWhen: (pre, cur) =>
            pre.processingOrdersList != cur.processingOrdersList ||
            pre.processingOrdersFilters != cur.processingOrdersFilters,
        builder: (context, state) {
          List<OrderInfo> orders = sortOrders(
            state.filteredProcessingOrdersList,
            _sortOption,
          );

          if (orders.isEmpty) {
            return const PrimaryEmptyData();
          }

          return Column(
            children: [
              const FindingShipperSearchWidget(),
              ProcessingOrdersSortSelectBar(
                totalCount: orders.length,
                selectedCount: _selectedOrderKeys.length,
                isAllSelected:
                    _selectedOrderKeys.length == orders.length &&
                    orders.isNotEmpty,
                sortOption: _sortOption,
                isSelectionMode: _selectedOrderKeys.isNotEmpty,
                onSelectAll: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedOrderKeys.addAll(
                        orders.map(_orderKey).whereType<String>(),
                      );
                    } else {
                      _selectedOrderKeys.clear();
                    }
                  });
                },
                onSortChanged: (val) {
                  if (val != null) {
                    setState(() => _sortOption = val);
                  }
                },
              ),
              const _TopActionButtons(),
              Expanded(
                child: PrimaryRefreshabelListView(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  enablePullUp: true,
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.smallSpacing,
                    horizontal: AppDimensions.smallSpacing,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) => OrderInfoItem(
                    index: index + 1,
                    order: orders[index],
                    isSelected: _isSelected(orders[index]),
                    isSelectionMode: _selectedOrderKeys.isNotEmpty,
                    onTap: _onOrderTap,
                    onLongPress: _enterSelectionMode,
                    onSelectionToggle: _toggleOrderSelection,
                  ),
                  separatorBuilder: (context, index) =>
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onRefresh() {
    _ordersBloc.fetchOrdersByStatus();
  }

  void _onLoading() {
    if (!_ordersBloc.state.hasData) {
      _refreshController.loadNoData();
      return;
    }

    _ordersBloc.loadMoreOrders();
  }

  String? _orderKey(OrderInfo order) => order.id;

  bool _isSelected(OrderInfo order) {
    final key = _orderKey(order);
    return key != null && _selectedOrderKeys.contains(key);
  }

  void _toggleOrderSelection(OrderInfo order) {
    final key = _orderKey(order);
    if (key == null) return;
    setState(() {
      if (_selectedOrderKeys.contains(key)) {
        _selectedOrderKeys.remove(key);
      } else {
        _selectedOrderKeys.add(key);
      }
    });
  }

  void _enterSelectionMode(OrderInfo order) {
    final key = _orderKey(order);
    if (key == null) return;
    setState(() => _selectedOrderKeys.add(key));
  }

  void _onOrderTap(OrderInfo order) {
    _ordersBloc.openOrderDetail(order);
  }

  void _listenOrdsListChanged(BuildContext context, OrdersState state) {
    final visibleOrderKeys = state.filteredProcessingOrdersList
        .map(_orderKey)
        .whereType<String>()
        .toSet();
    _selectedOrderKeys.removeWhere((key) => !visibleOrderKeys.contains(key));

    switch (state.orderListByStatusResource.state) {
      case Result.success:
        _refreshController
          ..refreshCompleted()
          ..loadComplete();
        break;
      case Result.error:
        _refreshController
          ..refreshFailed()
          ..loadFailed();
      default:
    }
  }
}

class _TopActionButtons extends StatelessWidget {
  const _TopActionButtons();

  @override
  Widget build(BuildContext context) {
    final PackagesBloc pkgsBloc = getIt.get();
    final OrdersBloc ordersBloc = getIt.get();

    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: ordersBloc,
      buildWhen: (pre, cur) =>
          pre.processingOrdersList != cur.processingOrdersList ||
          pre.processingOrdersFilters != cur.processingOrdersFilters,
      builder: (context, state) {
        List<OrderInfo> orders = state.filteredProcessingOrdersList;
        if (orders.isEmpty) return const SizedBox();

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
            vertical: AppDimensions.xSmallSpacing,
          ),
          child: PrimaryButton.warningFilled(
            label: "cancel_finding_shipper".tr(),
            height: AppDimensions.smallHeightButton,
            onPressed: pkgsBloc.cancelfindingShipper,
          ),
        );
      },
    );
  }
}
