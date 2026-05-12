import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_bloc.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_state.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/password_strength_indicator.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/staff_permission_config.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/staff_permission_section.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_form_footer.dart';

class CreateShopStaffPage extends StatefulWidget {
  const CreateShopStaffPage({super.key});

  @override
  State<CreateShopStaffPage> createState() => _CreateShopStaffPageState();
}

class _CreateShopStaffPageState extends State<CreateShopStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final ShopBloc _shopBloc = getIt.get();
  final ShopStaffBloc _shopStaffBloc = getIt.get();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  BriefShopEntity? _selectedShop;
  late Map<String, Map<String, bool>> _permissions;
  PasswordStrength _passwordStrength = PasswordStrength.empty;

  @override
  void initState() {
    super.initState();
    _selectedShop = _shopBloc.state.currentShop;
    _permissions = CreateShopStaffRequest.defaultPermissions();
    _passwordController.addListener(_handlePasswordChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_handlePasswordChanged);
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopStaffBloc, ShopStaffState>(
      bloc: _shopStaffBloc,
      listenWhen:
          (previous, current) =>
              previous.createStaffResource != current.createStaffResource,
      listener: _handleCreateStaffChanged,
      child: Scaffold(
        appBar: PrimaryAppBar(title: "shop_management.staff_add_title".tr()),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.mediumSpacing,
                    AppDimensions.xSmallSpacing,
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
                          child: PrimaryText(
                            "shop_management.staff_add_header".tr(),
                            style: AppTextStyles.titleMedium,
                            bold: true,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                        Center(
                          child: PrimaryText(
                            "shop_management.staff_add_subtitle".tr(),
                            style: AppTextStyles.bodyMedium,
                            color: AppColors.neutral4,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        BlocBuilder<ShopBloc, ShopState>(
                          bloc: _shopBloc,
                          buildWhen:
                              (previous, current) =>
                                  previous.briefShopsResource !=
                                      current.briefShopsResource ||
                                  previous.currentShop != current.currentShop,
                          builder: (context, state) {
                            final shops =
                                state.briefShopsResource.data?.data ?? const [];

                            return PrimaryDropdown<BriefShopEntity>(
                              label: "shop_management.staff_select_shop".tr(),
                              hintText: "select".tr(),
                              menu: shops,
                              initialValue: _selectedShop,
                              toLabel: (shop) => shop.shopName,
                              validator:
                                  (value) =>
                                      value == null
                                          ? "validate.text_required".tr()
                                          : null,
                              onSelected:
                                  (shop) =>
                                      setState(() => _selectedShop = shop),
                            );
                          },
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        PrimaryText(
                          "shop_management.staff_info".tr(),
                          style: AppTextStyles.titleMedium,
                          bold: true,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: _usernameController,
                          label: "shop_management.staff_username".tr(),
                          hintText: "enter_text".tr(),
                          isRequired: true,
                          textInputAction: TextInputAction.next,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.validateUsername,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: _passwordController,
                          label: "shop_management.staff_password".tr(),
                          hintText: "enter_text".tr(),
                          isRequired: true,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: _validatePassword,
                          helper: Align(
                            alignment: Alignment.centerRight,
                            child: PrimaryText(
                              "shop_management.staff_auto_password".tr(),
                              style: AppTextStyles.bodyMedium,
                              color: AppColors.neutral4,
                            ),
                          ),
                        ),
                        PasswordStrengthIndicator(
                          strength: _passwordStrength,
                        ),
                        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                        PrimaryText(
                          "shop_management.staff_password_instruction".tr(),
                          style: AppTextStyles.bodyMedium,
                          color: AppColors.neutral4,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: _fullNameController,
                          label: "shop_management.staff_full_name".tr(),
                          hintText: "enter_text".tr(),
                          isRequired: true,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.validateFullName,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: _emailController,
                          label: "shop_management.field_email".tr(),
                          hintText: "enter_text".tr(),
                          isRequired: true,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.validateEmail,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: _phoneController,
                          label: "shop_management.field_phone".tr(),
                          hintText: "enter_text".tr(),
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.validatePhoneNumber,
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        PrimaryText(
                          "shop_management.staff_permission".tr(),
                          style: AppTextStyles.titleMedium,
                          bold: true,
                        ),
                        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                        PrimaryText(
                          "shop_management.staff_permission_role".tr(),
                          style: AppTextStyles.bodyMedium,
                          color: AppColors.primary,
                        ),
                        PrimaryText(
                          "shop_management.staff_permission_description".tr(),
                          style: AppTextStyles.bodyMedium,
                          color: AppColors.green600,
                          maxLine: 2,
                        ),
                        AppSpacing.vertical(AppDimensions.xSmallSpacing),
                        ...List.generate(staffPermissionGroups.length, (index) {
                          final group = staffPermissionGroups[index];
                          return StaffPermissionSection(
                            group: group,
                            values: _permissions[group.key] ?? const {},
                            onChanged:
                                (action, value) => _handlePermissionChanged(
                                  group.key,
                                  action,
                                  value,
                                ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              ShopStaffFormFooter(
                primaryLabel: "shop_management.staff_create".tr(),
                onSubmit: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    final shopId = _selectedShop?.shopId;
    if (shopId == null || shopId.isEmpty) return;

    _shopStaffBloc.createStaff(
      userLogin: _usernameController.text.trim(),
      userPass: _passwordController.text.trim(),
      displayName: _fullNameController.text.trim(),
      userEmail: _emailController.text.trim(),
      userPhone: _phoneController.text.trim(),
      shopId: shopId,
      permissions: _permissions.map(
        (key, value) => MapEntry(key, Map<String, bool>.from(value)),
      ),
    );
  }

  void _handlePermissionChanged(String group, String action, bool value) {
    setState(() {
      _permissions[group] = Map<String, bool>.from(_permissions[group] ?? {})
        ..[action] = value;
    });
  }

  void _handlePasswordChanged() {
    setState(() {
      _passwordStrength = PasswordStrength.fromValue(
        _passwordController.text,
      );
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.password_required".tr();
    }
    if (value.length < 8) {
      return "shop_management.staff_password_min_length".tr();
    }
    return null;
  }

  void _handleCreateStaffChanged(BuildContext context, ShopStaffState state) {
    switch (state.createStaffResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        context.pop();
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.createStaffResource.message,
        );
        break;
    }
  }
}
