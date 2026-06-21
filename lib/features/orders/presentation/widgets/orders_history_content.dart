import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_filter_button.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_filter_panel.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_list_card.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class OrdersHistoryContent extends StatefulWidget {
  const OrdersHistoryContent({
    super.key,
    required this.controller,
    required this.isLoadingFor,
  });

  final TabController controller;
  final bool Function(OrderStatus status, OrdersState state) isLoadingFor;

  @override
  State<OrdersHistoryContent> createState() => _OrdersHistoryContentState();
}

class _OrdersHistoryContentState extends State<OrdersHistoryContent> {
  final OrdersBloc _ordersBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      builder: (context, state) {
        return Column(
          children: [
            // _OrdersHistoryListHeader(
            //   isExpanded: false,
            //   onToggle: ordersBloc.toggleOrdersHistoryFilters,
            // ),
            Expanded(
              child: TabBarView(
                controller: widget.controller,
                children: [
                  OrdersHistoryListCard(
                    status: OrderStatus.allProcessing,
                    orders: state.filteredAllOrdersHistoryList,
                    onRefresh:
                        () => _ordersBloc.fetchOrderHistory(
                          OrderStatus.allProcessing,
                        ),
                    onLoadMore:
                        () => _ordersBloc.loadMoreOrderHistory(
                          OrderStatus.allProcessing,
                        ),
                    onOrderTap: _onOrderTap,
                    isLoading: widget.isLoadingFor(
                      OrderStatus.allProcessing,
                      state,
                    ),
                  ),
                  OrdersHistoryListCard(
                    status: OrderStatus.delivered,
                    orders: state.filteredDeliveredOrdersHistoryList,
                    onRefresh:
                        () => _ordersBloc.fetchOrderHistory(
                          OrderStatus.delivered,
                        ),
                    onLoadMore:
                        () => _ordersBloc.loadMoreOrderHistory(
                          OrderStatus.delivered,
                        ),
                    onOrderTap: _onOrderTap,
                    isLoading: widget.isLoadingFor(
                      OrderStatus.delivered,
                      state,
                    ),
                  ),
                  OrdersHistoryListCard(
                    status: OrderStatus.returned,
                    orders: state.filteredReturnedOrdersHistoryList,
                    onRefresh:
                        () =>
                            _ordersBloc.fetchOrderHistory(OrderStatus.returned),
                    onLoadMore:
                        () => _ordersBloc.loadMoreOrderHistory(
                          OrderStatus.returned,
                        ),
                    onOrderTap: _onOrderTap,
                    isLoading: widget.isLoadingFor(OrderStatus.returned, state),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onOrderTap(OrdersHistoryEntity order) {
    _ordersBloc.openOrderHistoryDetail(order);
  }
}

class _OrdersHistoryListHeader extends StatelessWidget {
  const _OrdersHistoryListHeader({
    required this.isExpanded,
    required this.onToggle,
  });

  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.largeSpacing,
        AppDimensions.largeSpacing,
        AppDimensions.largeSpacing,
        AppDimensions.smallSpacing,
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryText(
              "processed_orders_list".tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral1,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          OrdersHistoryFilterButton(isExpanded: isExpanded, onTap: onToggle),
        ],
      ),
    );
  }
}
