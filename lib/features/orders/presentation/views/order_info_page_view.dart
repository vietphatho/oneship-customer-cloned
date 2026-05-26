import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/delivery_service_type_radio_group.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_map_preview.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/product_selected_container.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/product_selection_button.dart';

class OrderInfoPageView extends StatefulWidget {
  const OrderInfoPageView({super.key});

  @override
  State<OrderInfoPageView> createState() => _OrderInfoPageViewState();
}

class _OrderInfoPageViewState extends State<OrderInfoPageView>
    with AutomaticKeepAliveClientMixin {
  final CreateOrderBloc _createOrderBloc = getIt.get();

  final TextEditingController _codCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _lengthCtrl = TextEditingController();
  final TextEditingController _widthCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  final TextEditingController _externalOrderIdCtrl = TextEditingController();
  final TextEditingController _orderSourceCtrl = TextEditingController();

  // DeliveryServiceType _deliveryServiceType = DeliveryServiceType.standard;

  @override
  void initState() {
    super.initState();
    var request = _createOrderBloc.state.request;
    _codCtrl.text = Utils.formatCurrencyInput(request.codAmount);
    _weightCtrl.text = request.detail?.weight?.toInt().toString() ?? "";
    _lengthCtrl.text = request.detail?.length?.toString() ?? "";
    _widthCtrl.text = request.detail?.width?.toString() ?? "";
    _heightCtrl.text = request.detail?.height?.toString() ?? "";
    _noteCtrl.text = request.detail?.note ?? "";
    _externalOrderIdCtrl.text = request.externalOrderId ?? "";
    // _orderSourceCtrl.text = request.o
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final isStepValid = (int.tryParse(_weightCtrl.text) ?? 0) > 0;

    super.build(context);
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
                  PrimaryText(
                    "order_info".tr(),
                    style: AppTextStyles.labelLarge,
                    color: AppColors.secondary,
                  ),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  //
                  const ProductSelectionButton(),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  const ProductSelectedContainer(),
                  //
                  AppSpacing.vertical(AppDimensions.xxLargeSpacing),
                  const DeliveryServiceTypeRadioGroup(),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextField(
                          label: "cod".tr(),
                          controller: _codCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          inputFormatters: [_CurrencyTextInputFormatter()],
                          suffixText: Constants.currencyUnit,
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
                    onChanged: (_) => setState(() {}),
                    suffixText: Constants.weightUnit,
                  ),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextField(
                          label: "length".tr(),
                          controller: _lengthCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          suffixText: Constants.pkgDimensionsUnit,
                        ),
                      ),
                      AppSpacing.horizontal(AppDimensions.smallSpacing),
                      Expanded(
                        child: PrimaryTextField(
                          label: "width".tr(),
                          controller: _widthCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          suffixText: Constants.pkgDimensionsUnit,
                        ),
                      ),
                      AppSpacing.horizontal(AppDimensions.smallSpacing),
                      Expanded(
                        child: PrimaryTextField(
                          label: "height".tr(),
                          controller: _heightCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          suffixText: Constants.pkgDimensionsUnit,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextField(
                          label: "external_order_id".tr(),
                          controller: _externalOrderIdCtrl,
                          // onChanged: (_) => setState(() {}),
                        ),
                      ),
                      AppSpacing.horizontal(AppDimensions.smallSpacing),
                      Expanded(
                        child: PrimaryTextField(
                          label: "order_source".tr(),
                          controller: _orderSourceCtrl,
                          // onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  // AppSpacing.vertical(AppDimensions.smallSpacing),
                  // PrimaryDropdown(),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  PrimaryTextField(
                    label: "note".tr(),
                    maxLine: 5,
                    controller: _noteCtrl,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          CreateOrderMapPreview(),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton.outlined(
                    label: "previous".tr(),
                    onPressed: _onPrevious,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: SecondaryButton.filled(
                    label: "done".tr(),
                    onPressed: isStepValid ? _onNext : null,
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
    final ProductBloc productBloc = getIt.get();
    _createOrderBloc.completeOrderInfoStep(
      codAmount: Utils.parseCurrencyInput(_codCtrl.text),
      weight: int.tryParse(_weightCtrl.text) ?? 0,
      length: int.tryParse(_lengthCtrl.text),
      width: int.tryParse(_widthCtrl.text),
      height: int.tryParse(_heightCtrl.text),
      note: _noteCtrl.text,
      externalOrderId: _externalOrderIdCtrl.text,
      orderSource: _orderSourceCtrl.text,
      selectedProducts: productBloc.state.productsListSelected,
    );
  }
}

class _CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final amount = Utils.parseCurrencyInput(newValue.text);
    if (amount == 0 && newValue.text.isEmpty) {
      return const TextEditingValue();
    }

    final formatted = Utils.formatCurrencyInput(amount);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
