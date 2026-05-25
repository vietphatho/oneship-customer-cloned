import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_dialog.dart';
import 'package:oneship_shop/core/base/components/secondary_button.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/di/injection_container.dart';
import 'package:oneship_shop/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_shop/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_shop/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_shop/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_shop/features/shop_staff/domain/entities/shop_staff_detail_entity.dart';
import 'package:oneship_shop/features/shop_staff/presentation/bloc/shop_staff_bloc.dart';
import 'package:oneship_shop/features/shop_staff/presentation/bloc/shop_staff_state.dart';
import 'package:oneship_shop/features/shop_staff/presentation/widgets/shop_staff_badges.dart';
import 'package:oneship_shop/features/shop_staff/presentation/widgets/staff_permission_config.dart';
import 'package:oneship_shop/features/shop_staff/presentation/widgets/staff_permission_section.dart';

class AddShopToStaffPage extends StatefulWidget {
  const AddShopToStaffPage({super.key});

  @override
  State<AddShopToStaffPage> createState() => _AddShopToStaffPageState();
}

class _AddShopToStaffPageState extends State<AddShopToStaffPage> {
  final ShopBloc _shopBloc = getIt.get();
  final ShopStaffBloc _shopStaffBloc = getIt.get();

  BriefShopEntity? _selectedShop;
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
      listenWhen:
          (previous, current) =>
              previous.addStaffToShopResource != current.addStaffToShopResource,
      listener: _handleAddStaffToShopChanged,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: "shop_management.staff_add_shop_title".tr(),
        ),
        body: SafeArea(
          child: BlocBuilder<ShopStaffBloc, ShopStaffState>(
            bloc: _shopStaffBloc,
            buildWhen:
                (previous, current) =>
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
                    _ShopSelectionSection(
                      shopBloc: _shopBloc,
                      selectedShop: _selectedShop,
                      onSelected:
                          (shop) => setState(() => _selectedShop = shop),
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
                    ValueListenableBuilder<Map<String, Map<String, bool>>>(
                      valueListenable: _permissionsNotifier,
                      builder: (context, permissions, child) {
                        return Column(
                          children:
                              staffPermissionGroups.map((group) {
                                return StaffPermissionSection(
                                  group: group,
                                  values: permissions[group.key] ?? const {},
                                  onChanged:
                                      (action, value) =>
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
    final shopId = _selectedShop?.shopId;
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

class _ShopSelectionSection extends StatelessWidget {
  const _ShopSelectionSection({
    required this.shopBloc,
    required this.selectedShop,
    required this.onSelected,
  });

  final ShopBloc shopBloc;
  final BriefShopEntity? selectedShop;
  final ValueChanged<BriefShopEntity?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          "shop_management.staff_shop_info".tr(),
          style: AppTextStyles.titleMedium,
          bold: true,
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        BlocBuilder<ShopBloc, ShopState>(
          bloc: shopBloc,
          buildWhen:
              (previous, current) =>
                  previous.briefShopsResource != current.briefShopsResource ||
                  previous.currentShop != current.currentShop,
          builder: (context, state) {
            final shops = state.briefShopsResource.data?.data ?? const [];
            return PrimaryDropdown<BriefShopEntity>(
              key: ValueKey(selectedShop?.shopId),
              label: "shop_management.staff_select_shop".tr(),
              hintText: "select".tr(),
              menu: shops,
              initialValue: selectedShop,
              toLabel: (shop) => shop.shopName,
              onSelected: onSelected,
            );
          },
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        Row(
          children: [
            PrimaryText(
              "shop_management.field_status".tr(),
              style: AppTextStyles.bodyMedium,
              color: AppColors.neutral4,
            ),
            const Spacer(),
            ShopStaffStatusBadge(isActive: selectedShop?.isActive == true),
          ],
        ),
      ],
    );
  }
}
