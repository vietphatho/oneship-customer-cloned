import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_option_selection_content.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class HandlingSelectionPage extends StatelessWidget {
  HandlingSelectionPage({super.key});

  final ShopBloc _shopBloc = getIt.get();
  final CreateOrderBloc _createOrderBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      bloc: _shopBloc,
      buildWhen: (previous, current) =>
          previous.handlingTypesResource != current.handlingTypesResource,
      builder: (context, shopState) {
        return BlocBuilder<CreateOrderBloc, CreateOrderState>(
          bloc: _createOrderBloc,
          buildWhen: (previous, current) =>
              previous.draftRequest.detail?.handlingType !=
              current.draftRequest.detail?.handlingType,
          builder: (context, orderState) {
            return OrderOptionSelectionContent(
              title: "handling_type".tr(),
              resource: shopState.handlingTypesResource,
              selectedCodes:
                  orderState.draftRequest.detail?.handlingType ?? const [],
              onToggle: _createOrderBloc.toggleHandlingType,
            );
          },
        );
      },
    );
  }
}
