import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/delivery_service_type_radio_group.dart';

class OrderInfoPageView extends StatefulWidget {
  const OrderInfoPageView({super.key});

  @override
  State<OrderInfoPageView> createState() => _OrderInfoPageViewState();
}

class _OrderInfoPageViewState extends State<OrderInfoPageView> {
  final CreateOrderBloc _createOrderBloc = getIt.get();

  final TextEditingController _codCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _lengthCtrl = TextEditingController();
  final TextEditingController _widthCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  // DeliveryServiceType _deliveryServiceType = DeliveryServiceType.standard;

  @override
  Widget build(BuildContext context) {
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
                  PrimaryText("order_info".tr()),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  const DeliveryServiceTypeRadioGroup(),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextField(
                          label: "cod".tr(),
                          controller: _codCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      // AppSpacing.horizontal(AppDimensions.smallSpacing),
                      // Expanded(child: PrimaryTextField(lableText: "cod")),
                    ],
                  ),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  PrimaryTextField(
                    label: "weight".tr(),
                    isRequired: true,
                    controller: _weightCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextField(
                          label: "length".tr(),
                          controller: _lengthCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      AppSpacing.horizontal(AppDimensions.smallSpacing),
                      Expanded(
                        child: PrimaryTextField(
                          label: "width".tr(),
                          controller: _widthCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      AppSpacing.horizontal(AppDimensions.smallSpacing),
                      Expanded(
                        child: PrimaryTextField(
                          label: "height".tr(),
                          controller: _heightCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  // AppSpacing.vertical(AppDimensions.smallSpacing),
                  // PrimaryTextField(label: "source"),
                  // AppSpacing.vertical(AppDimensions.smallSpacing),
                  // PrimaryDropdown(),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  PrimaryTextField(
                    label: "note".tr(),
                    maxLine: 5,
                    controller: _noteCtrl,
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          //map view
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
                    label: "done".tr(),
                    onPressed: _onNext,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPrevious() {
    // _createOrderBloc.changeStep(CreateOrderStep.receiverInfo);
    _createOrderBloc.backToStep(CreateOrderStep.receiverInfo);
  }

  void _onNext() {
    _createOrderBloc.completeOrderInfoStep(
      codAmount: int.tryParse(_codCtrl.text) ?? 0,
      weight: int.tryParse(_weightCtrl.text) ?? 0,
      length: int.tryParse(_lengthCtrl.text),
      width: int.tryParse(_widthCtrl.text),
      height: int.tryParse(_heightCtrl.text),
      note: _noteCtrl.text,
    );
  }
}
