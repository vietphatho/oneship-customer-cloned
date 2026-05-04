import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_viewdart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_list_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class OrdersHistoryListCard extends StatefulWidget {
  const OrdersHistoryListCard({
    super.key,
    required this.status,
    this.isLoading = false,
  });

  final OrderStatus status;
  final bool isLoading;

  @override
  State<OrdersHistoryListCard> createState() => _OrdersHistoryListCardState();
}

class _OrdersHistoryListCardState extends State<OrdersHistoryListCard> {
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OrdersBloc ordersBloc = getIt.get();
    final orders =
        switch (widget.status) {
              OrderStatus.delivered =>
                ordersBloc.visibleDeliveredArchivedOrdersList,
              OrderStatus.returned => ordersBloc.visibleReturnedArchivedOrdersList,
              _ => <OrderInfo>[],
            };

    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return PrimaryRefreshabelListView(
      controller: _refreshController,
      itemCount: orders.length,
      enablePullUp: false,
      onRefresh: () {
        ordersBloc.fetchArchivedOrders(widget.status);
        _refreshController.refreshCompleted();
      },
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrdersHistoryListItem(
          index: index + 1,
          order: order,
        );
      },
      separatorBuilder:
          (_, __) => AppSpacing.vertical(AppDimensions.smallSpacing),
    );
  }
}
