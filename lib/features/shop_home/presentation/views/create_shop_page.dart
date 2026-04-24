import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_auto_complete_text_field.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/models/create_shop_form_value.dart';

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
        appBar: PrimaryAppBar(title: 'Thêm cửa hàng'),
        body: BlocBuilder<LocationServiceBloc, LocationServiceState>(
          bloc: _locationServiceBloc,
          buildWhen:
              (previous, current) =>
                  previous.provinces != current.provinces ||
                  previous.wardsByProvince != current.wardsByProvince,
          builder: (context, state) {
            _ensureDefaultProvince(state);
            final provinces = state.provinces;
            final wards = _wardsForSelectedProvince(state);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.mediumSpacing,
                      AppDimensions.mediumSpacing,
                      AppDimensions.mediumSpacing,
                      MediaQuery.of(context).viewInsets.bottom +
                          AppDimensions.mediumSpacing,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryTextField(
                            controller: _shopNameController,
                            label: 'Tên cửa hàng',
                            hintText: 'Nhập tên cửa hàng',
                            isRequired: true,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            validateMode: AutovalidateMode.onUserInteraction,
                            validator: _validateShopName,
                          ),
                          AppSpacing.vertical(AppDimensions.mediumSpacing),
                          PrimaryTextField(
                            controller: _emailController,
                            label: 'Email liên hệ',
                            hintText: 'shop@example.com',
                            isRequired: true,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validateMode: AutovalidateMode.onUserInteraction,
                            validator: _validateEmail,
                          ),
                          AppSpacing.vertical(AppDimensions.mediumSpacing),
                          PrimaryTextField(
                            controller: _phoneController,
                            label: 'Số điện thoại',
                            hintText: 'Nhập số điện thoại',
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
                          PrimaryDropdown<Province>(
                            key: ValueKey(_selectedProvince?.code ?? -1),
                            label: 'Thành phố',
                            hintText: 'Chọn thành phố',
                            isRequired: true,
                            menu: provinces,
                            initialValue: _selectedProvince,
                            toLabel: (item) => item.name,
                            validator:
                                (value) =>
                                    value == null
                                        ? 'Vui lòng chọn thành phố'
                                        : null,
                            onSelected: (value) {
                              setState(() {
                                _selectedProvince = value;
                                _selectedWard = null;
                                _selectedAddress = null;
                                _addressController.clear();
                              });
                            },
                          ),
                          AppSpacing.vertical(AppDimensions.mediumSpacing),
                          PrimaryDropdown<Ward>(
                            key: ValueKey(
                              '${_selectedProvince?.code ?? -1}-${_selectedWard?.code ?? -1}',
                            ),
                            label: 'Xã/Phường',
                            hintText: 'Chọn xã/phường',
                            isRequired: true,
                            menu: wards,
                            initialValue: _selectedWard,
                            toLabel: (item) => item.name,
                            validator:
                                (value) =>
                                    value == null
                                        ? 'Vui lòng chọn xã/phường'
                                        : null,
                            onSelected: (value) {
                              setState(() {
                                _selectedWard = value;
                                _selectedAddress = null;
                                _addressController.clear();
                              });
                            },
                          ),
                          AppSpacing.vertical(AppDimensions.mediumSpacing),
                          PrimaryAutoCompleteTextField<
                            SuggestedAddressResponse
                          >(
                            controller: _addressController,
                            label: 'Địa chỉ',
                            hintText: 'Nhập địa chỉ và chọn gợi ý phù hợp',
                            instruction:
                                'Địa chỉ cần được chọn từ gợi ý để lấy đúng vị trí cửa hàng',
                            isRequired: true,
                            enabled:
                                _selectedProvince != null &&
                                _selectedWard != null,
                            textCapitalization: TextCapitalization.sentences,
                            validateMode: AutovalidateMode.onUserInteraction,
                            validator: _validateAddress,
                            displayStringForOption:
                                (item) => item.display ?? '',
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
                const Divider(height: 1),
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
                            shopState.createShopResource.state ==
                            Result.loading;

                        return Row(
                          children: [
                            Expanded(
                              child: PrimaryButton.secondary(
                                label: 'Hủy',
                                onPressed:
                                    isSubmitting
                                        ? null
                                        : () => Navigator.of(context).pop(),
                              ),
                            ),
                            AppSpacing.horizontal(AppDimensions.smallSpacing),
                            Expanded(
                              child: PrimaryButton.primary(
                                label:
                                    isSubmitting
                                        ? 'Đang xử lý...'
                                        : 'Tạo cửa hàng',
                                onPressed: isSubmitting ? null : _handleSubmit,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleCreateShopChanged(
    BuildContext context,
    ShopState state,
  ) async {
    switch (state.createShopResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        if (PrimaryDialog.isShowLoading) {
          PrimaryDialog.hideLoadingDialog(context);
        }
        if (state.createShopResource.data != null) {
          _shopBloc.resetCreateShopResource();
          _shopBloc.init(state.userId);
          PrimaryDialog.showSuccessDialog(
            context,
            title: 'Thành công',
            message: 'Tạo cửa hàng thành công. Hệ thống đang chờ xét duyệt.',
          );
          await Future.delayed(Durations.short2);
          if (context.mounted) Navigator.of(context).pop();
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

  void _ensureDefaultProvince(LocationServiceState state) {
    if (_selectedProvince != null || state.provinces.isEmpty) return;

    final fallbackProvince = state.provinces.firstWhereOrNull(
      (province) => province.code == _defaultProvinceCode,
    );

    _selectedProvince = fallbackProvince ?? state.provinces.first;
  }

  List<Ward> _wardsForSelectedProvince(LocationServiceState state) {
    final provinceCode = _selectedProvince?.code.toString();
    if (provinceCode == null) return const [];

    return state.wardsByProvince[provinceCode] ?? const [];
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
