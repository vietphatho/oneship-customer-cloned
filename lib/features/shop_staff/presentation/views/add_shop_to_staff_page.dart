import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_detail_entity.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_bloc.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_state.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_shop_selector.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/staff_permission_config.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/staff_permission_section.dart';

class AddShopToStaffPage extends StatefulWidget {
  const AddShopToStaffPage({super.key});

  @override
  State<AddShopToStaffPage> createState() => _AddShopToStaffPageState();
}

class _AddShopToStaffPageState extends State<AddShopToStaffPage> {
  final ShopBloc _shopBloc = getIt.get();
  final ShopStaffBloc _shopStaffBloc = getIt.get();

  late final ValueNotifier<Map<String, Map<String, bool>>> _permissionsNotifier;

  @override
  void initState() {
    super.initState();
    _permissionsNotifier = ValueNotifier(
      CreateShopStaffRequest.defaultPermissions(),
    );
  }

  @override
  void dispose() {
    _permissionsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopStaffBloc, ShopStaffState>(
      bloc: _shopStaffBloc,
      listenWhen: (previous, current) =>
          previous.addStaffToShopResource != current.addStaffToShopResource,
      listener: _handleAddStaffToShopChanged,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: "shop_management.staff_add_shop_title".tr(),
        ),
        body: SafeArea(
          child: BlocBuilder<ShopStaffBloc, ShopStaffState>(
            bloc: _shopStaffBloc,
            buildWhen: (previous, current) =>
                previous.staffDetailResource != current.staffDetailResource,
            builder: (context, state) {
              final staff = state.staffDetailResource.data;
              if (staff == null) {
                return Center(
                  child: PrimaryText(
                    "shop_management.staff_detail_not_found".tr(),
                    style: AppTextStyles.bodyMedium,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.mediumSpacing,
                  AppDimensions.xSmallSpacing,
                  AppDimensions.mediumSpacing,
                  AppDimensions.mediumSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: PrimaryText(
                        "shop_management.staff_create".tr(),
                        style: AppTextStyles.titleMedium,
                        bold: true,
                      ),
                    ),
                    AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
                    Center(
                      child: PrimaryText(
                        staff.displayName,
                        style: AppTextStyles.bodyMedium,
                        color: AppColors.neutral4,
                      ),
                    ),
                    AppSpacing.vertical(AppDimensions.largeSpacing),
                    ShopStaffShopSelector(),
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
                    ValueListenableBuilder<Map<String, Map<String, bool>>>(
                      valueListenable: _permissionsNotifier,
                      builder: (context, permissions, child) {
                        return Column(
                          children: staffPermissionGroups.map((group) {
                            return StaffPermissionSection(
                              group: group,
                              values: permissions[group.key] ?? const {},
                              onChanged: (action, value) =>
                                  _handlePermissionChanged(
                                    group.key,
                                    action,
                                    value,
                                  ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    AppSpacing.vertical(AppDimensions.largeSpacing),
                    SecondaryButton.filled(
                      label: "shop_management.save_changes".tr(),
                      onPressed: () => _handleSubmit(staff),
                      height: AppDimensions.smallHeightButton,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handlePermissionChanged(String group, String action, bool value) {
    final permissions = Map<String, Map<String, bool>>.from(
      _permissionsNotifier.value,
    );
    permissions[group] = Map<String, bool>.from(permissions[group] ?? {})
      ..[action] = value;
    _permissionsNotifier.value = permissions;
  }

  void _handleSubmit(ShopStaffDetailEntity staff) {
    final shopId = _shopBloc.state.currentShop?.shopId;
    if (shopId == null || shopId.isEmpty) {
      PrimaryDialog.showErrorDialog(
        context,
        message: "shop_management.staff_select_shop_required".tr(),
      );
      return;
    }

    _shopStaffBloc.addStaffToShop(
      shopId: shopId,
      userId: staff.userId,
      permissions: _permissionsNotifier.value.map(
        (key, value) => MapEntry(key, Map<String, bool>.from(value)),
      ),
    );
  }

  void _handleAddStaffToShopChanged(
    BuildContext context,
    ShopStaffState state,
  ) {
    switch (state.addStaffToShopResource.state) {
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
          message: state.addStaffToShopResource.message,
        );
        break;
    }
  }
}
