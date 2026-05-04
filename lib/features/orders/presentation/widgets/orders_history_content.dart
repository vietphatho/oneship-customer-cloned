import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_filter_button.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_filter_panel.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_list_card.dart';

class OrdersHistoryContent extends StatelessWidget {
  const OrdersHistoryContent({
    super.key,
    required this.controller,
    required this.ordersBloc,
    required this.state,
    required this.isLoadingFor,
  });

  final TabController controller;
  final OrdersBloc ordersBloc;
  final OrdersState state;
  final bool Function(OrderStatus status, OrdersState state) isLoadingFor;

  @override
  Widget build(BuildContext context) {
    final isFilterExpanded = state.showOrdersHistoryFilters;

    if (isFilterExpanded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppDimensions.mediumSpacing),
        child: Column(
          children: [
            _OrdersHistoryListHeader(
              isExpanded: true,
              onToggle: ordersBloc.toggleOrdersHistoryFilters,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.mediumSpacing,
                0,
                AppDimensions.mediumSpacing,
                AppDimensions.smallSpacing,
              ),
              child: OrdersHistoryFilterPanel(
                initialFilters: state.ordersHistoryFilters,
                maxCodAmount: ordersBloc.ordersHistoryMaxCodAmount,
                onApply: ordersBloc.applyOrdersHistoryFilters,
                onClear: ordersBloc.clearOrdersHistoryFilters,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _OrdersHistoryListHeader(
          isExpanded: false,
          onToggle: ordersBloc.toggleOrdersHistoryFilters,
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              OrdersHistoryListCard(
                status: OrderStatus.delivered,
                orders: ordersBloc.visibleDeliveredArchivedOrdersList,
                onRefresh:
                    () => ordersBloc.fetchOrderHistory(OrderStatus.delivered),
                isLoading: isLoadingFor(OrderStatus.delivered, state),
              ),
              OrdersHistoryListCard(
                status: OrderStatus.returned,
                orders: ordersBloc.visibleReturnedArchivedOrdersList,
                onRefresh:
                    () => ordersBloc.fetchOrderHistory(OrderStatus.returned),
                isLoading: isLoadingFor(OrderStatus.returned, state),
              ),
            ],
          ),
        ),
      ],
    );
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
            child: Text(
              "Danh sách đơn hàng đã xử lý",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral1,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          OrdersHistoryFilterButton(
            isExpanded: isExpanded,
            onTap: onToggle,
          ),
        ],
      ),
    );
  }
}
