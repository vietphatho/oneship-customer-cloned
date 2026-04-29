import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_auto_complete_text_field.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/create_shop_form_value.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_pending_approval_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_province_selector.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_ward_selector.dart';

class CreateShopPage extends StatefulWidget {
  const CreateShopPage({super.key});

  @override
  State<CreateShopPage> createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  static const int _defaultProvinceCode = 79;

  final _formKey = GlobalKey<FormState>();
  final LocationServiceBloc _locationServiceBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Province? _selectedProvince;
  Ward? _selectedWard;
  SuggestedAddressResponse? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _ensureDefaultProvince();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc, ShopState>(
      bloc: _shopBloc,
      listenWhen:
          (previous, current) =>
              previous.createShopResource != current.createShopResource,
      listener: _handleCreateShopChanged,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.mediumSpacing,
                    AppDimensions.xxxLargeSpacing,
                    AppDimensions.mediumSpacing,
                    MediaQuery.of(context).viewInsets.bottom +
                        AppDimensions.mediumSpacing,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            ImagePath.logo,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                        PrimaryTextField(
                          controller: _shopNameController,
                          label: 'Tên cửa hàng',
                          hintText: 'Nhập',
                          isRequired: true,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: _validateShopName,
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        PrimaryTextField(
                          controller: _phoneController,
                          label: 'Số điện thoại',
                          hintText: 'Nhập',
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: _validatePhone,
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        PrimaryTextField(
                          controller: _emailController,
                          label: 'Email',
                          hintText: 'Nhập',
                          isRequired: true,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: _validateEmail,
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        ShopProvinceSelector(
                          initialProvince: _selectedProvince,
                          onChanged: (value) {
                            setState(() {
                              _selectedProvince = value;
                              _selectedWard = null;
                              _selectedAddress = null;
                              _addressController.clear();
                            });
                          },
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        ShopWardSelector(
                          provinceCode: _selectedProvince?.code,
                          initialWard: _selectedWard,
                          onChanged: (value) {
                            setState(() {
                              _selectedWard = value;
                              _selectedAddress = null;
                              _addressController.clear();
                            });
                          },
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        PrimaryAutoCompleteTextField<SuggestedAddressResponse>(
                          controller: _addressController,
                          label: 'Địa chỉ',
                          hintText: 'Nhập',
                          instruction:
                              'Vui lòng nhập ít nhất 7 ký tự cho địa chỉ',
                          isRequired: true,
                          fillColor: Colors.white,
                          enabled:
                              _selectedProvince != null &&
                              _selectedWard != null,
                          textCapitalization: TextCapitalization.sentences,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: _validateAddress,
                          displayStringForOption: (item) => item.display ?? '',
                          onSearch: _searchAddress,
                          onSelected: (value) {
                            setState(() {
                              _selectedAddress = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.mediumSpacing,
                    AppDimensions.smallSpacing,
                    AppDimensions.mediumSpacing,
                    AppDimensions.mediumSpacing,
                  ),
                  child: BlocBuilder<ShopBloc, ShopState>(
                    bloc: _shopBloc,
                    buildWhen:
                        (previous, current) =>
                            previous.createShopResource !=
                            current.createShopResource,
                    builder: (context, shopState) {
                      final isSubmitting =
                          shopState.createShopResource.state == Result.loading;

                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                              label: 'Hủy',
                              onPressed:
                                  isSubmitting
                                      ? null
                                      : () => Navigator.of(context).pop(),
                              backgroundColor: Colors.white,
                              borderColor: AppColors.neutral7,
                              textColor: AppColors.neutral6,
                            ),
                          ),
                          AppSpacing.horizontal(AppDimensions.xxxLargeSpacing),
                          Expanded(
                            flex: 3,
                            child: PrimaryButton(
                              label:
                                  isSubmitting
                                      ? 'Đang xử lý...'
                                      : 'Tạo cửa hàng',
                              onPressed: isSubmitting ? null : _handleSubmit,
                              backgroundColor: AppColors.secondary,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreateShopChanged(
    BuildContext context,
    ShopState state,
  ) async {
    switch (state.createShopResource.state) {
      case Result.idle:
        break;
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        if (PrimaryDialog.isShowLoading) {
          PrimaryDialog.hideLoadingDialog(context);
        }
        final createdShop = state.createShopResource.data;
        if (createdShop != null) {
          _shopBloc.resetCreateShopResource();
          _shopBloc.init(state.userId);
          await Navigator.of(context).pushReplacement<void, void>(
            MaterialPageRoute(
              builder:
                  (_) =>
                      ShopPendingApprovalPage(shopName: createdShop.shopName),
            ),
          );
        }
        break;
      case Result.error:
        if (PrimaryDialog.isShowLoading) {
          PrimaryDialog.hideLoadingDialog(context);
        }
        _shopBloc.resetCreateShopResource();
        PrimaryDialog.showErrorDialog(
          context,
          message:
              state.createShopResource.message.isEmpty
                  ? 'Không thể tạo cửa hàng'
                  : state.createShopResource.message,
        );
        break;
    }
  }

  void _ensureDefaultProvince() {
    final state = _locationServiceBloc.state;
    if (_selectedProvince != null || state.provinces.isEmpty) return;

    final fallbackProvince = state.provinces.firstWhereOrNull(
      (province) => province.code == _defaultProvinceCode,
    );

    _selectedProvince = fallbackProvince ?? state.provinces.first;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProvince == null || _selectedWard == null) return;
    if (_selectedAddress?.refId == null) return;

    _shopBloc.submitCreateShopForm(
      CreateShopFormValue(
        shopName: _shopNameController.text.trim(),
        contactEmail: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        provinceCode: _selectedProvince!.code,
        provinceName: _selectedProvince!.name,
        wardCode: _selectedWard!.code,
        wardName: _selectedWard!.name,
        fullAddress: _addressController.text.trim(),
        vietMapRefId: _selectedAddress!.refId!,
      ),
    );
  }

  String? _validateShopName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập tên cửa hàng';
    if (trimmed.length < 3) return 'Tên cửa hàng phải có ít nhất 3 ký tự';
    return null;
  }

  String? _validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập email liên hệ';

    const emailPattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(trimmed)) {
      return 'Email không đúng định dạng';
    }

    return null;
  }

  String? _validatePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (!RegExp(r'^0\d{9,10}$').hasMatch(trimmed)) {
      return 'Số điện thoại Việt Nam không đúng định dạng';
    }
    return null;
  }

  String? _validateAddress(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập địa chỉ';
    if (trimmed.length < 7) return 'Địa chỉ phải có ít nhất 7 ký tự';
    if (_selectedAddress?.display != trimmed ||
        _selectedAddress?.refId == null) {
      return 'Vui lòng chọn một địa chỉ từ danh sách gợi ý';
    }
    return null;
  }

  Future<List<SuggestedAddressResponse>> _searchAddress(String keyword) async {
    if (_selectedProvince == null || _selectedWard == null) return [];

    return _locationServiceBloc.searchAddress(
      province: _selectedProvince!,
      ward: _selectedWard!,
      address: keyword,
    );
  }
}
