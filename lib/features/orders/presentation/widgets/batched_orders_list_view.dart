import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';

class BatchedOrdersListView extends StatefulWidget {
  const BatchedOrdersListView({super.key});

  @override
  State<BatchedOrdersListView> createState() => _BatchedOrdersListViewState();
}

class _BatchedOrdersListViewState extends State<BatchedOrdersListView> {
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
      buildWhen: (pre, cur) => pre.batchedOrdersList != cur.batchedOrdersList,
      builder: (context, state) {
        List<OrderInfo> _orders = state.batchedOrdersList;

        return ListView.separated(
          itemCount: _orders.length,
          itemBuilder:
              (context, index) =>
                  OrderInfoItem(index: index + 1, order: _orders[index]),
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }
}
