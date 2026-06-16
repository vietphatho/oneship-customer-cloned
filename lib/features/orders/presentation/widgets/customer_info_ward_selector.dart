import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

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
      buildWhen: (pre, cur) =>
          cur is LocationServiceProvincesChangedState ||
          cur is LocationServiceWardsChangedState,
      builder: (context, state) {
        return BlocBuilder<CreateOrderBloc, CreateOrderState>(
          bloc: _createOrderBloc,
          buildWhen: (previous, current) =>
              previous.draftRequest.ward != current.draftRequest.ward,
          builder: (context, createOrdState) {
            final wards = state.wardsByProvince[_hcmProvinceCode] ?? [];
            if (wards.isEmpty) return const SizedBox();

            final draftWard = createOrdState.draftRequest.ward;
            final selectedWard = draftWard != null
                ? wards.firstWhereOrNull((ward) => ward.code == draftWard.code)
                : null;

            return PrimaryDropdown(
              label: "ward".tr(),
              isRequired: true,
              initialValue: selectedWard,
              menu: wards,
              toLabel: (item) => item.name,
              onSelected: (value) {
                _createOrderBloc.changeCustomerInfo(ward: value);
              },
            );
          },
        );
      },
    );
  }
}
