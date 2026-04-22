import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';

class CustomerInfoWardSelector extends StatefulWidget {
  const CustomerInfoWardSelector({super.key});

  @override
  State<CustomerInfoWardSelector> createState() =>
      _CustomerInfoWardSelectorState();
}

class _CustomerInfoWardSelectorState extends State<CustomerInfoWardSelector> {
  static const String _hcmProvinceCode = '79';

  final CreateOrderBloc _createOrderBloc = getIt.get();
  final LocationServiceBloc _locationServiceBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationServiceBloc, LocationServiceState>(
      bloc: _locationServiceBloc,
      buildWhen:
          (pre, cur) =>
              cur is LocationServiceProvincesChangedState ||
              cur is LocationServiceWardsChangedState,
      builder: (context, state) {
        final wards = state.wardsByProvince[_hcmProvinceCode] ?? [];
        if (wards.isEmpty) return const SizedBox();

        return PrimaryDropdown(
          label: "ward".tr(),
          initialValue: _createOrderBloc.state.draftRequest.ward,
          menu: wards,
          toLabel: (item) => item.name,
          onSelected: (value) {
            _createOrderBloc.changeCustomerInfo(ward: value);
          },
        );
      },
    );
  }
}
