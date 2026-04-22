import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_auto_complete_text_field.dart';
import 'package:oneship_customer/core/base/components/primary_radio_group.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/customer_info_province_selector.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/customer_info_ward_selector.dart';

enum ReceiverAddressOption { newAddress, oldAddress }

class ReceiverInfoPageView extends StatefulWidget {
  const ReceiverInfoPageView({super.key});

  @override
  State<ReceiverInfoPageView> createState() => _ReceiverInfoPageViewState();
}

class _ReceiverInfoPageViewState extends State<ReceiverInfoPageView> {
  final CreateOrderBloc _createOrderBloc = getIt.get();
  final LocationServiceBloc _locationServiceBloc = getIt.get();
  static final RegExp _vnPhoneRegex = RegExp(r'^0\d{9}$');

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    var request = _createOrderBloc.state.request;
    _nameCtrl.text = request.recipientName;
    _phoneCtrl.text = request.recipientPhone;
    _addressCtrl.text = request.fullAddress ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      buildWhen: (_, state) => state is CreateOrderCustomerInfoChangedState,
      builder: (context, state) {
        final phone = _phoneCtrl.text.trim();
        final hasValidPhone = _vnPhoneRegex.hasMatch(phone);
        final isStepValid =
            _nameCtrl.text.trim().isNotEmpty &&
            hasValidPhone &&
            _addressCtrl.text.trim().isNotEmpty &&
            state.draftRequest.province != null &&
            state.draftRequest.ward != null;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText("recipient_info".tr()),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      PrimaryTextField(
                        label: "recipient_name".tr(),
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onChanged:
                            (value) => _createOrderBloc.changeCustomerInfo(
                              name: value,
                            ),
                      ),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      PrimaryTextField(
                        label: "phone_number".tr(),
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged:
                            (value) => _createOrderBloc.changeCustomerInfo(
                              phoneNumber: value,
                            ),
                      ),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      PrimaryRadioGroup<ReceiverAddressOption>(
                        title: "address_type".tr(),
                        direction: Axis.horizontal,
                        options: ReceiverAddressOption.values,
                        value:
                            (state.draftRequest.isNewAddress ?? true)
                                ? ReceiverAddressOption.newAddress
                                : ReceiverAddressOption.oldAddress,
                        displayLabel:
                            (item) =>
                                item == ReceiverAddressOption.newAddress
                                    ? "new_address".tr()
                                    : "old_address".tr(),
                        onChanged:
                            (value) => _createOrderBloc.changeCustomerInfo(
                              isNewAddress:
                                  value == ReceiverAddressOption.newAddress,
                            ),
                      ),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      const CustomerInfoProvinceSelector(),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      const CustomerInfoWardSelector(),
                      // AppSpacing.vertical(AppDimensions.smallSpacing),
                      // PrimaryDropdown(),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      PrimaryAutoCompleteTextField(
                        label: "address".tr(),
                        enabled: state.isEnableAddressField,
                        controller: _addressCtrl,
                        displayStringForOption: (item) => item.display ?? "--",
                        onSearch:
                            (value) => _locationServiceBloc.searchAddress(
                              province: state.draftRequest.province!,
                              ward: state.draftRequest.ward!,
                              address: value,
                            ),
                        onSelected:
                            (value) => _createOrderBloc.changeCustomerInfo(
                              address: value.display,
                              destinationRefId: value.refId,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              //map view
              Expanded(
                flex: 2,
                child: Container(height: 200, color: Colors.green),
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton.secondaryButton(
                        label: "previous".tr(),
                        onPressed: _onPrevious,
                      ),
                    ),
                    AppSpacing.horizontal(AppDimensions.smallSpacing),
                    Expanded(
                      child: PrimaryButton.primaryButton(
                        label: "next".tr(),
                        onPressed: isStepValid ? _onNext : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPrevious() {
    // _createOrderBloc.changeStep(CreateOrderStep.timeInfo);
    _createOrderBloc.backToStep(CreateOrderStep.timeInfo);
  }

  void _onNext() {
    // _createOrderBloc.changeStep(CreateOrderStep.orderInfo);
    _createOrderBloc.completeCustomerInfoStep(
      customerName: _nameCtrl.text,
      phoneNumber: _phoneCtrl.text,
      address: _addressCtrl.text,
    );
  }
}
