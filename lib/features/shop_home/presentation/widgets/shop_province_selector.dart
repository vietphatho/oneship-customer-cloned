import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';

class ShopProvinceSelector extends StatefulWidget {
  const ShopProvinceSelector({
    super.key,
    required this.onChanged,
    this.initialProvince,
  });

  final ValueChanged<Province?> onChanged;
  final Province? initialProvince;

  @override
  State<ShopProvinceSelector> createState() => _ShopProvinceSelectorState();
}

class _ShopProvinceSelectorState extends State<ShopProvinceSelector> {
  final LocationServiceBloc _locationServiceBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationServiceBloc, LocationServiceState>(
      bloc: _locationServiceBloc,
      buildWhen: (previous, current) => previous.provinces != current.provinces,
      builder: (context, state) {
        final provinces = state.provinces;

        return PrimaryDropdown<Province>(
          key: ValueKey(widget.initialProvince?.code ?? -1),
          label: "city".tr(),
          hintText: "enter_text".tr(),
          isRequired: true,
          menu: provinces,
          initialValue: widget.initialProvince,
          toLabel: (item) => item.name,
          validator:
              (value) => value == null ? "please_select_city".tr() : null,
          onSelected: (value) {
            widget.onChanged(value);
          },
        );
      },
    );
  }
}
