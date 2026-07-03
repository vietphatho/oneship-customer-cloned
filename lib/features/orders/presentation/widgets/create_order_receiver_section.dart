import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_auto_complete_text_field.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/customer_info_province_selector.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/customer_info_ward_selector.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_map_preview.dart';

class CreateOrderReceiverSection extends StatelessWidget {
  const CreateOrderReceiverSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.onChanged,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final createOrderBloc = getIt.get<CreateOrderBloc>();
    final locationServiceBloc = getIt.get<LocationServiceBloc>();
    double mapViewHeight = MediaQuery.of(context).size.height * 0.28;

    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: createOrderBloc,
      buildWhen: (previous, current) =>
          previous.draftRequest.province != current.draftRequest.province ||
          previous.draftRequest.ward != current.draftRequest.ward,
      builder: (context, state) {
        return Column(
          children: [
            CreateOrderMapPreview(height: mapViewHeight),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            PrimaryTextField(
              label: "name".tr(),
              isRequired: true,
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(
                Icons.person_outline,
                size: AppDimensions.xSmallIconSize,
                color: AppColors.primary,
              ),
              onChanged: (value) {
                createOrderBloc.changeCustomerInfo(name: value);
                onChanged();
              },
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            PrimaryTextField(
              label: "phone_number".tr(),
              isRequired: true,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(
                Icons.phone_outlined,
                size: AppDimensions.xSmallIconSize,
                color: AppColors.primary,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: (value) {
                createOrderBloc.changeCustomerInfo(phoneNumber: value);
                onChanged();
              },
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            const CustomerInfoProvinceSelector(),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            const CustomerInfoWardSelector(),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            PrimaryAutoCompleteTextField(
              label: "address".tr(),
              isRequired: true,
              enabled: state.isEnableAddressField,
              controller: addressController,
              displayStringForOption: (item) => item.display ?? "--",
              onSearch: (value) {
                if (value.trim().length < 5) return Future.value([]);
                return locationServiceBloc.searchAddress(
                  province: state.draftRequest.province!,
                  ward: state.draftRequest.ward!,
                  address: value,
                );
              },
              onSelected: (value) {
                createOrderBloc.changeCustomerInfo(
                  address: value.display,
                  destinationRefId: value.refId,
                );
                onChanged();
              },
            ),
          ],
        );
      },
    );
  }
}
