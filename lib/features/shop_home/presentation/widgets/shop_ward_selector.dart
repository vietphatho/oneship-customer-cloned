import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';

class ShopWardSelector extends StatefulWidget {
  const ShopWardSelector({
    super.key,
    required this.provinceCode,
    required this.onChanged,
    this.initialWard,
  });

  final int? provinceCode;
  final ValueChanged<Ward?> onChanged;
  final Ward? initialWard;

  @override
  State<ShopWardSelector> createState() => _ShopWardSelectorState();
}

class _ShopWardSelectorState extends State<ShopWardSelector> {
  final LocationServiceBloc _locationServiceBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationServiceBloc, LocationServiceState>(
      bloc: _locationServiceBloc,
      buildWhen:
          (previous, current) =>
              previous.wardsByProvince != current.wardsByProvince,
      builder: (context, state) {
        final provinceCode = widget.provinceCode?.toString();
        final wards =
            provinceCode != null
                ? (state.wardsByProvince[provinceCode] ?? const [])
                : const <Ward>[];

        return PrimaryDropdown<Ward>(
          key: ValueKey(
            '${widget.provinceCode ?? -1}-${widget.initialWard?.code ?? -1}',
          ),
          label: 'Xã/Phường',
          hintText: 'Nhập',
          isRequired: true,
          menu: wards,
          initialValue: widget.initialWard,
          toLabel: (item) => item.name,
          validator:
              (value) => value == null ? 'Vui lòng chọn xã/phường' : null,
          onSelected: (value) {
            widget.onChanged(value);
          },
        );
      },
    );
  }
}
