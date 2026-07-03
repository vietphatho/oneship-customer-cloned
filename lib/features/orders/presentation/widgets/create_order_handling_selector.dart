import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_option_selector_field.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class CreateOrderHandlingSelector extends StatelessWidget {
  CreateOrderHandlingSelector({super.key});

  final CreateOrderBloc _createOrderBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      bloc: _shopBloc,
      buildWhen: (previous, current) =>
          previous.handlingTypesResource != current.handlingTypesResource,
      builder: (context, _) {
        return BlocBuilder<CreateOrderBloc, CreateOrderState>(
          bloc: _createOrderBloc,
          buildWhen: (previous, current) =>
              previous.draftRequest.detail?.handlingType !=
              current.draftRequest.detail?.handlingType,
          builder: (context, _) {
            return CreateOrderOptionSelectorField(
              label: "handling_type".tr(),
              selectedNames: _createOrderBloc.selectedHandlingTypeNames(),
              routeName: RouteName.handlingSelectionPage,
            );
          },
        );
      },
    );
  }
}
