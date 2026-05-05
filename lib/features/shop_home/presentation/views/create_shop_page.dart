import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_auto_complete_text_field.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/components/tertiary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_form_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/create_shop_footer.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/create_shop_form_content.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_province_selector.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_ward_selector.dart';

class CreateShopPage extends StatefulWidget {
  const CreateShopPage({super.key});

  @override
  State<CreateShopPage> createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  final _formKey = GlobalKey<FormState>();
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CreateShopFormContent(
                  formKey: _formKey,
                  shopNameController: _shopNameController,
                  phoneController: _phoneController,
                  emailController: _emailController,
                  addressController: _addressController,
                  selectedProvince: _selectedProvince,
                  selectedWard: _selectedWard,
                  selectedAddress: _selectedAddress,
                  onProvinceChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                      _selectedWard = null;
                      _selectedAddress = null;
                      _addressController.clear();
                    });
                  },
                  onWardChanged: (value) {
                    setState(() {
                      _selectedWard = value;
                      _selectedAddress = null;
                      _addressController.clear();
                    });
                  },
                  onAddressSelected: (value) {
                    setState(() {
                      _selectedAddress = value;
                    });
                  },
                  shopBloc: _shopBloc,
                ),
              ),
              CreateShopFooter(
                shopBloc: _shopBloc,
                onSubmit: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreateShopChanged(
    BuildContext context,
    ShopState state,
  ) {
    switch (state.createShopResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        final createdShop = state.createShopResource.data;
        if (createdShop != null) {
          _shopBloc.init(state.userId);
          context.pushReplacement(
            RouteName.shopPendingApprovalPage,
          );
        }
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.createShopResource.message,
        );
        break;
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProvince == null || _selectedWard == null) return;
    if (_selectedAddress?.refId == null) return;

    _shopBloc.submitCreateShopForm(
      CreateShopFormEntity(
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

}
