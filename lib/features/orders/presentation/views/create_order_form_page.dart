import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/views/confirmation_info_page_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_bottom_bar.dart';
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
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  PackageSize? _packageSize;

  @override
  void initState() {
    super.initState();
    final request = _createOrderBloc.state.request;
    _nameCtrl.text = request.customerName ?? "";
    _phoneCtrl.text = request.phone ?? "";
    _addressCtrl.text = request.fullAddress ?? "";
    _weightCtrl.text = request.detail?.weight?.toInt().toString() ?? "";
    _noteCtrl.text = request.detail?.note ?? "";
    _packageSize = request.packageSize ?? _findPackageSizeFromDimensions();
    _createOrderBloc.init();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _weightCtrl.dispose();
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
                          packageSize: _packageSize,
                          noteController: _noteCtrl,
                          onChanged: _refresh,
                          onWeightChanged: _changeWeight,
                          onPackageSizeChanged: _changePackageSize,
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

  void _refresh() => setState(() {});

  void _changePackageSize(PackageSize? packageSize) {
    setState(() => _packageSize = packageSize);
  }

  void _changeWeight(String value) {
    _createOrderBloc.changeOrderInfo(weight: Utils.parseCurrencyInput(value));
  }

  bool _isValid(CreateOrderState state) {
    bool isValidPhoneNum =
        Validators.validatePhoneNumber(_phoneCtrl.text.trim()) == null;
    return _nameCtrl.text.trim().isNotEmpty &&
        isValidPhoneNum &&
        _addressCtrl.text.trim().isNotEmpty &&
        state.draftRequest.province != null &&
        state.draftRequest.ward != null &&
        state.draftRequest.serviceConfig != null &&
        Utils.parseCurrencyInput(_weightCtrl.text) > 0 &&
        !_createOrderBloc.hasInvalidSelectedSurcharges(state);
  }

  void _onNext() {
    final dimensions = _parseDimensions(_packageSize);
    _createOrderBloc.completeCreateOrderForm(
      customerName: _nameCtrl.text,
      phoneNumber: _phoneCtrl.text,
      address: _addressCtrl.text,
      weight: Utils.parseCurrencyInput(_weightCtrl.text),
      packageSize: _packageSize,
      length: dimensions.$1,
      width: dimensions.$2,
      height: dimensions.$3,
      note: _noteCtrl.text,
      selectedProducts: _productBloc.state.productsListSelected,
    );
  }

  PackageSize? _findPackageSizeFromDimensions() {
    final request = _createOrderBloc.state.request;
    final dimensions = [
      request.detail?.length,
      request.detail?.width,
      request.detail?.height,
    ].whereType<num>().map((value) => value.toInt()).join("x");

    if (dimensions.isEmpty) return null;
    return PackageSize.values.firstWhereOrNull(
      (item) => item.dimensions == dimensions,
    );
  }

  (int?, int?, int?) _parseDimensions(PackageSize? packageSize) {
    final values =
        packageSize?.dimensions
            .split("x")
            .map((value) => int.tryParse(value.trim()))
            .toList() ??
        [];
    return (
      values.isNotEmpty ? values[0] : null,
      values.length > 1 ? values[1] : null,
      values.length > 2 ? values[2] : null,
    );
  }
}
