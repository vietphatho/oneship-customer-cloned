import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_radio_group.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class DeliveryServiceTypeRadioGroup extends StatefulWidget {
  const DeliveryServiceTypeRadioGroup({super.key});

  @override
  State<DeliveryServiceTypeRadioGroup> createState() =>
      _DeliveryServiceTypeRadioGroupState();
}

class _DeliveryServiceTypeRadioGroupState
    extends State<DeliveryServiceTypeRadioGroup> {
  final CreateOrderBloc _createOrderBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      builder: (context, state) {
        CreateOrderRequestEntity draftRequest =
            _createOrderBloc.state.draftRequest;

        return PrimaryRadioGroup(
          direction: Axis.horizontal,
          title: "delivery_service_type".tr(),
          isRequired: true,
          options: DeliveryServiceType.values,
          subTitle: (value) => value.description.tr(),
          value: draftRequest.serviceCode,
          displayLabel: (value) => value.nameValue.tr(),
          onChanged: _onChanged,
        );
      },
    );
  }

  void _onChanged(DeliveryServiceType value) {
    _createOrderBloc.changeOrderInfo(deliveryServiceType: value);
  }
}
