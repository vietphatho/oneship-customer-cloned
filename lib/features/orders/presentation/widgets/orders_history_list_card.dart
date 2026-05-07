import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/orders_history_list_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class OrdersHistoryListCard extends StatefulWidget {
  const OrdersHistoryListCard({
    super.key,
    required this.status,
    required this.orders,
    required this.onRefresh,
    this.isLoading = false,
  });

  final OrderStatus status;
  final List<OrderHistoryInfoEntity> orders;
  final VoidCallback onRefresh;
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
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return PrimaryRefreshabelListView(
      controller: _refreshController,
      itemCount: widget.orders.length,
      enablePullUp: false,
      onRefresh: () {
        widget.onRefresh();
        _refreshController.refreshCompleted();
      },
      itemBuilder: (context, index) {
        final order = widget.orders[index];
        return OrdersHistoryListItem(index: index + 1, order: order);
      },
      separatorBuilder:
          (_, __) => AppSpacing.vertical(AppDimensions.smallSpacing),
    );
  }
}
