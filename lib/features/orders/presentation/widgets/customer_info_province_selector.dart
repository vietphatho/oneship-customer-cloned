import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';

class CustomerInfoProvinceSelector extends StatefulWidget {
  const CustomerInfoProvinceSelector({super.key});

  @override
  State<CustomerInfoProvinceSelector> createState() =>
      _CustomerInfoProvinceSelectorState();
}

class _CustomerInfoProvinceSelectorState
    extends State<CustomerInfoProvinceSelector> {
  final CreateOrderBloc _createOrderBloc = getIt.get();
  final LocationServiceBloc _locationServiceBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationServiceBloc, LocationServiceState>(
      bloc: _locationServiceBloc,
      buildWhen: (pre, cur) => cur is LocationServiceProvincesChangedState,
      builder: (context, state) {
        if (state is! LocationServiceProvincesChangedState) return SizedBox();

        return PrimaryDropdown(
          label: "province".tr(),
          menu: state.filteredProvinces,
          toLabel: (item) => item.name,
          onSelected: (value) {
            _createOrderBloc.changeCustomerInfo(province: value);
            _locationServiceBloc.searchWard("", province: value!);
          },
        );
      },
    );
  }
}
