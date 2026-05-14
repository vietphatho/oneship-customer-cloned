import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';

class DeliveringOrdersListView extends StatefulWidget {
  const DeliveringOrdersListView({super.key});

  @override
  State<DeliveringOrdersListView> createState() =>
      _DeliveringOrdersListViewState();
}

class _DeliveringOrdersListViewState extends State<DeliveringOrdersListView> {
  final OrdersBloc _ordersBloc = getIt.get();

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
          (pre, cur) => pre.deliveringOrdersList != cur.deliveringOrdersList,
      builder: (context, state) {
        List<OrderInfo> _orders = state.deliveringOrdersList;

        if (_orders.isEmpty) {
          return SafeArea(top: false, child: const PrimaryEmptyData());
        }

        return ListView.separated(
          itemCount: _orders.length,
          itemBuilder:
              (context, index) => OrderInfoItem(
                index: index + 1,
                order: _orders[index],
                onTap: _ordersBloc.openOrderDetail,
              ),
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }
}
