import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_auto_complete_text_field.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_province_selector.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_ward_selector.dart';

class CreateShopFormContent extends StatelessWidget {
  const CreateShopFormContent({
    super.key,
    required this.formKey,
    required this.shopNameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.selectedProvince,
    required this.selectedWard,
    required this.selectedAddress,
    required this.onProvinceChanged,
    required this.onWardChanged,
    required this.onAddressSelected,
    required this.shopBloc,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController shopNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final Province? selectedProvince;
  final Ward? selectedWard;
  final SuggestedAddressResponse? selectedAddress;
  final ValueChanged<Province?> onProvinceChanged;
  final ValueChanged<Ward?> onWardChanged;
  final ValueChanged<SuggestedAddressResponse?> onAddressSelected;
  final ShopBloc shopBloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        AppDimensions.xxxLargeSpacing,
        AppDimensions.mediumSpacing,
        MediaQuery.of(context).viewInsets.bottom + AppDimensions.mediumSpacing,
      ),
      child: Form(
        key: formKey,
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
              controller: shopNameController,
              label: 'shop_name'.tr(),
              hintText: 'enter_text'.tr(),
              isRequired: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validateMode: AutovalidateMode.onUserInteraction,
              validator: Validators.validateShopName,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            PrimaryTextField(
              controller: phoneController,
              label: 'phone_number'.tr(),
              hintText: 'enter_text'.tr(),
              isRequired: true,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validateMode: AutovalidateMode.onUserInteraction,
              validator: Validators.validatePhone,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            PrimaryTextField(
              controller: emailController,
              label: 'email'.tr(),
              hintText: 'enter_text'.tr(),
              isRequired: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validateMode: AutovalidateMode.onUserInteraction,
              validator: Validators.validateEmail,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            ShopProvinceSelector(
              initialProvince: selectedProvince,
              onChanged: onProvinceChanged,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            ShopWardSelector(
              provinceCode: selectedProvince?.code,
              initialWard: selectedWard,
              onChanged: onWardChanged,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            PrimaryAutoCompleteTextField<SuggestedAddressResponse>(
              controller: addressController,
              label: 'address'.tr(),
              hintText: 'enter_text'.tr(),
              instruction: 'please_enter_at_least_7_characters_for_address'.tr(),
              isRequired: true,
              fillColor: Colors.white,
              enabled: selectedProvince != null && selectedWard != null,
              textCapitalization: TextCapitalization.sentences,
              validateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => Validators.validateAddress(
                value,
                selectedAddress: selectedAddress,
              ),
              displayStringForOption: (item) => item.display ?? '',
              onSearch: (keyword) => shopBloc.searchAddress(
                province: selectedProvince!,
                ward: selectedWard!,
                keyword: keyword,
              ),
              onSelected: onAddressSelected,
            ),
          ],
        ),
      ),
    );
  }
}
