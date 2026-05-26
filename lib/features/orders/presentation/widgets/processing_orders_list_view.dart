import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/finding_shipper_search_widget.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';
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

  @override
  void initState() {
    super.initState();
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
        buildWhen:
            (pre, cur) => pre.processingOrdersList != cur.processingOrdersList,
        builder: (context, state) {
          List<OrderInfo> orders = state.processingOrdersList;

          if (orders.isEmpty) {
            return const PrimaryEmptyData();
          }

          return Column(
            children: [
              const FindingShipperSearchWidget(),
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
                    onTap: _ordersBloc.openOrderDetail,
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

  void _listenOrdsListChanged(BuildContext context, OrdersState state) {
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
          pre.processingOrdersList != cur.processingOrdersList,
      builder: (context, state) {
        List<OrderInfo> orders = state.processingOrdersList;
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
