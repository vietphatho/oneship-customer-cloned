import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';

class ProcessingOrdersListView extends StatefulWidget {
  const ProcessingOrdersListView({super.key});

  @override
  State<ProcessingOrdersListView> createState() =>
      _ProcessingOrdersListViewState();
}

class _ProcessingOrdersListViewState extends State<ProcessingOrdersListView> {
  final OrdersBloc _ordersBloc = getIt.get();
  final PackagesBloc _pkgsBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _ordersBloc.fetchOrdersByStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopActionButtons(),
        BlocBuilder<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          buildWhen:
              (pre, cur) =>
                  pre.processingOrdersList != cur.processingOrdersList,
          builder: (context, state) {
            List<OrderInfo> _orders = state.processingOrdersList;

            if (_orders.isEmpty) {
              return Center(child: const PrimaryEmptyData());
            }

            return Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  vertical: AppDimensions.smallSpacing,
                  horizontal: AppDimensions.smallSpacing,
                ),
                itemCount: _orders.length,
                itemBuilder:
                    (context, index) =>
                        OrderInfoItem(index: index + 1, order: _orders[index]),
                separatorBuilder:
                    (context, index) =>
                        AppSpacing.vertical(AppDimensions.xSmallSpacing),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TopActionButtons extends StatelessWidget {
  const _TopActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final PackagesBloc _pkgsBloc = getIt.get();
    final OrdersBloc _ordersBloc = getIt.get();

    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      buildWhen:
          (pre, cur) => pre.processingOrdersList != cur.processingOrdersList,
      builder: (context, state) {
        List<OrderInfo> _orders = state.processingOrdersList;
        if (_orders.isEmpty) return const SizedBox();

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: PrimaryButton.warningFilled(
            label: "cancel_finding_shipper".tr(),
            height: AppDimensions.smallHeightButton,
            onPressed: _pkgsBloc.cancelfindingShipper,
          ),
        );
      },
    );
  }
}
