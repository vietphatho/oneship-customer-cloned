import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_bloc.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_state.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/widgets/vendor_order_card.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class VendorOrdersList extends StatefulWidget {
  const VendorOrdersList({super.key, required this.tab});

  final VendorOrdersTab tab;

  @override
  State<VendorOrdersList> createState() => _VendorOrdersListState();
}

class _VendorOrdersListState extends State<VendorOrdersList> {
  final RefreshController _refreshController = RefreshController();
  bool _isLoadingMore = false;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<VendorOrdersBloc>();

    return BlocConsumer<VendorOrdersBloc, VendorOrdersState>(
      bloc: bloc,
      listenWhen: (previous, current) {
        return switch (widget.tab) {
          VendorOrdersTab.processing =>
            previous.processingOrdersResource !=
                current.processingOrdersResource,
          VendorOrdersTab.archived =>
            previous.archivedOrdersResource != current.archivedOrdersResource,
        };
      },
      listener: _handleResourceChanged,
      buildWhen: (previous, current) {
        return switch (widget.tab) {
          VendorOrdersTab.processing =>
            previous.processingOrdersResource !=
                    current.processingOrdersResource ||
                previous.processingOrders != current.processingOrders,
          VendorOrdersTab.archived =>
            previous.archivedOrdersResource != current.archivedOrdersResource ||
                previous.archivedOrders != current.archivedOrders,
        };
      },
      builder: (context, state) {
        final resource = state.ordersResource(widget.tab);
        final orders = state.orders(widget.tab);

        if (resource.state == Result.loading && orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (resource.state == Result.error && orders.isEmpty) {
          return PrimaryEmptyData(onRetry: _retry);
        }

        return PrimaryRefreshabelListView(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: state.hasMoreOrders(widget.tab),
          onRefresh: _refresh,
          onLoading: _loadMore,
          padding: const EdgeInsets.only(bottom: 150),
          itemCount: orders.length,
          separatorBuilder: (context, index) =>
              AppSpacing.vertical(AppDimensions.smallSpacing),
          itemBuilder: (context, index) {
            return VendorOrderCard(order: orders[index], tab: widget.tab);
          },
        );
      },
    );
  }

  void _retry() {
    final bloc = getIt.get<VendorOrdersBloc>();

    switch (widget.tab) {
      case VendorOrdersTab.processing:
        bloc.retryProcessingOrders();
        break;
      case VendorOrdersTab.archived:
        bloc.retryArchivedOrders();
        break;
    }
  }

  void _refresh() {
    _isLoadingMore = false;
    getIt.get<VendorOrdersBloc>().refreshOrders(widget.tab);
  }

  void _loadMore() {
    final bloc = getIt.get<VendorOrdersBloc>();
    if (!bloc.state.hasMoreOrders(widget.tab)) {
      _refreshController.loadNoData();
      return;
    }

    _isLoadingMore = true;
    bloc.loadMoreOrders(widget.tab);
  }

  void _handleResourceChanged(BuildContext context, VendorOrdersState state) {
    final resource = state.ordersResource(widget.tab);

    switch (resource.state) {
      case Result.success:
        if (_isLoadingMore) {
          _refreshController.loadComplete();
          if (!state.hasMoreOrders(widget.tab)) {
            _refreshController.loadNoData();
          }
        } else {
          _refreshController
            ..refreshCompleted()
            ..resetNoData();
        }
        _isLoadingMore = false;
        break;
      case Result.error:
        if (_isLoadingMore) {
          _refreshController.loadFailed();
        } else {
          _refreshController.refreshFailed();
        }
        _isLoadingMore = false;
        break;
      case Result.loading:
        break;
    }
  }
}
