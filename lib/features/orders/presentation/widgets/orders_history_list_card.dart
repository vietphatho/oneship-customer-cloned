import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_list_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class OrdersHistoryListCard extends StatefulWidget {
  const OrdersHistoryListCard({
    super.key,
    required this.status,
    required this.orders,
    required this.onRefresh,
    required this.onLoadMore,
    this.onOrderTap,
    this.isLoading = false,
  });

  final OrderStatus status;
  final List<OrdersHistoryEntity> orders;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final ValueChanged<OrdersHistoryEntity>? onOrderTap;
  final bool isLoading;

  @override
  State<OrdersHistoryListCard> createState() => _OrdersHistoryListCardState();
}

class _OrdersHistoryListCardState extends State<OrdersHistoryListCard> {
  final OrdersBloc _ordersBloc = getIt.get();
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      listenWhen:
          (previous, current) =>
              previous.ordersHistoryResource != current.ordersHistoryResource,
      listener: _listenOrdersHistoryChanged,
      child:
          widget.isLoading
              ? const Center(child: CircularProgressIndicator())
              : PrimaryRefreshabelListView(
                controller: _refreshController,
                itemCount: widget.orders.length,
                enablePullUp: true,
                onRefresh: widget.onRefresh,
                onLoading: _onLoading,
                itemBuilder: (context, index) {
                  final order = widget.orders[index];
                  return OrdersHistoryListItem(
                    index: index + 1,
                    order: order,
                    onTap:
                        widget.onOrderTap != null
                            ? () => widget.onOrderTap!(order)
                            : null,
                  );
                },
                separatorBuilder:
                    (_, __) =>
                        AppSpacing.vertical(AppDimensions.smallSpacing),
              ),
    );
  }

  void _onLoading() {
    if (!_ordersBloc.hasMoreOrderHistory(widget.status)) {
      _refreshController.loadNoData();
      return;
    }

    widget.onLoadMore();
  }

  void _listenOrdersHistoryChanged(BuildContext context, OrdersState state) {
    switch (state.ordersHistoryResource.state) {
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
