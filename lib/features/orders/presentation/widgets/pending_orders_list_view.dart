import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';

class PendingOrdersListView extends StatefulWidget {
  const PendingOrdersListView({super.key});

  @override
  State<PendingOrdersListView> createState() => _PendingOrdersListViewState();
}

class _PendingOrdersListViewState extends State<PendingOrdersListView> {
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
          (_, state) => _ordersBloc.currentOrderStatus == OrderStatus.pending,
      builder: (context, state) {
        List<OrderInfo> _orders = _ordersBloc.pendingOrdersList;

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
                  AppDimensions.mediumSpacing,
                ),
                child: PrimaryButton.primaryButton(
                  label: "find_shipper".tr(),
                  onPressed: () {
                    _pkgsBloc.findShipper();
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
