import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/views/confirmation_info_page_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_bottom_bar.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_cod_bottom_sheet.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_goods_section.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_product_selector.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_receiver_section.dart';

class CreateOrderFormPage extends StatelessWidget {
  const CreateOrderFormPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _CreateOrderForm(),
        SizedBox.shrink(),
        ConfirmationInfoPageView(),
      ],
    );
  }
}

class _CreateOrderForm extends StatefulWidget {
  const _CreateOrderForm();

  @override
  State<_CreateOrderForm> createState() => _CreateOrderFormState();
}

class _CreateOrderFormState extends State<_CreateOrderForm> {
  final CreateOrderBloc _createOrderBloc = getIt.get();
  final LocationServiceBloc _locationServiceBloc = getIt.get();
  final ProductBloc _productBloc = getIt.get();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _codCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _dimensionsCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final request = _createOrderBloc.state.request;
    _nameCtrl.text = request.customerName ?? "";
    _phoneCtrl.text = request.phone ?? "";
    _addressCtrl.text = request.fullAddress ?? "";
    _codCtrl.text = Utils.formatCurrencyInput(request.codAmount);
    _weightCtrl.text = request.detail?.weight?.toInt().toString() ?? "";
    _dimensionsCtrl.text = [
      request.detail?.length,
      request.detail?.width,
      request.detail?.height,
    ].whereType<num>().map((value) => value.toInt()).join(" x ");
    _noteCtrl.text = request.detail?.note ?? "";
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _codCtrl.dispose();
    _weightCtrl.dispose();
    _dimensionsCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      builder: (context, state) {
        return ColoredBox(
          color: AppColors.neutral9,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
                  child: Column(
                    children: [
                      _section(
                        title: "recipient".tr(),
                        child: CreateOrderReceiverSection(
                          state: state,
                          createOrderBloc: _createOrderBloc,
                          locationServiceBloc: _locationServiceBloc,
                          nameController: _nameCtrl,
                          phoneController: _phoneCtrl,
                          addressController: _addressCtrl,
                          onChanged: _refresh,
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _section(
                        title: "goods".tr(),
                        child: const CreateOrderProductSection(),
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _section(
                        title: "order_info".tr(),
                        child: CreateOrderGoodsSection(
                          weightController: _weightCtrl,
                          dimensionsController: _dimensionsCtrl,
                          codController: _codCtrl,
                          noteController: _noteCtrl,
                          onChanged: _refresh,
                          onCodTap: _showCodInput,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CreateOrderBottomBar(
                onContinue: _isValid(state) ? _onNext : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section({required String title, required Widget child}) {
    return PrimaryFrame(
      padding: const EdgeInsets.all(AppDimensions.smallSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            title,
            style: AppTextStyles.labelLarge,
            color: AppColors.primary,
            bold: true,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          child,
        ],
      ),
    );
  }

  Future<void> _showCodInput() async {
    await showCreateOrderCodBottomSheet(
      context,
      controller: _codCtrl,
    );
    _refresh();
  }

  void _refresh() => setState(() {});

  bool _isValid(CreateOrderState state) {
    return _nameCtrl.text.trim().isNotEmpty &&
        RegExp(r'^0\d{9}$').hasMatch(_phoneCtrl.text.trim()) &&
        _addressCtrl.text.trim().isNotEmpty &&
        state.draftRequest.province != null &&
        state.draftRequest.ward != null &&
        Utils.parseCurrencyInput(_weightCtrl.text) > 0;
  }

  void _onNext() {
    final dimensions = _parseDimensions();
    _createOrderBloc.completeCreateOrderForm(
      customerName: _nameCtrl.text,
      phoneNumber: _phoneCtrl.text,
      address: _addressCtrl.text,
      codAmount: Utils.parseCurrencyInput(_codCtrl.text),
      weight: Utils.parseCurrencyInput(_weightCtrl.text),
      length: dimensions.$1,
      width: dimensions.$2,
      height: dimensions.$3,
      note: _noteCtrl.text,
      selectedProducts: _productBloc.state.productsListSelected,
    );
  }

  (int?, int?, int?) _parseDimensions() {
    final values =
        _dimensionsCtrl.text
            .split(RegExp(r"[xX*]"))
            .map((value) => int.tryParse(value.trim()))
            .toList();
    return (
      values.isNotEmpty ? values[0] : null,
      values.length > 1 ? values[1] : null,
      values.length > 2 ? values[2] : null,
    );
  }
}
