import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/components/primary_button.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
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
    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      buildWhen:
          (_, state) =>
              _ordersBloc.currentOrderStatus == OrderStatus.processing,
      builder: (context, state) {
        List<OrderInfo> _orders = _ordersBloc.processingOrdersList;

        if (_orders.isEmpty) {
          return SafeArea(top: false, child: const PrimaryEmptyData());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  vertical: AppDimensions.smallSpacing,
                ),
                itemCount: _orders.length,
                itemBuilder:
                    (context, index) =>
                        OrderInfoItem(index: index + 1, order: _orders[index]),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.mediumSpacing,
                  AppDimensions.mediumSpacing,
                  AppDimensions.mediumSpacing,
                  100,
                ),
                child: PrimaryButton.outlined(
                  label: "cancel_finding_shipper",
                  onPressed: () {
                    _pkgsBloc.cancelfindingShipper();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
