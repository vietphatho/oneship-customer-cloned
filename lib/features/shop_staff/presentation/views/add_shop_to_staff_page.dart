import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_detail_entity.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_bloc.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_state.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_badges.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/staff_permission_config.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/staff_permission_section.dart';

class AddShopToStaffPage extends StatefulWidget {
  const AddShopToStaffPage({super.key, this.staff});

  final ShopStaffDetailEntity? staff;

  @override
  State<AddShopToStaffPage> createState() => _AddShopToStaffPageState();
}

class _AddShopToStaffPageState extends State<AddShopToStaffPage> {
  final ShopBloc _shopBloc = getIt.get();
  final ShopStaffBloc _shopStaffBloc = getIt.get();

  BriefShopEntity? _selectedShop;
  late Map<String, Map<String, bool>> _permissions;

  @override
  void initState() {
    super.initState();
    _permissions = CreateShopStaffRequest.defaultPermissions();
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
        appBar: PrimaryAppBar(title: "shop_management.staff_add_shop_title".tr()),
        body: SafeArea(
          child:
              widget.staff == null
                  ? Center(
                    child: PrimaryText(
                      "shop_management.staff_detail_not_found".tr(),
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                  : SingleChildScrollView(
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
                            widget.staff?.displayName,
                            style: AppTextStyles.bodyMedium,
                            color: AppColors.neutral4,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.largeSpacing),
                        PrimaryText(
                          "shop_management.staff_shop_info".tr(),
                          style: AppTextStyles.titleMedium,
                          bold: true,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
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
                              key: ValueKey(_selectedShop?.shopId),
                              label: "shop_management.staff_select_shop".tr(),
                              hintText: "select".tr(),
                              menu: shops,
                              initialValue: _selectedShop,
                              toLabel: (shop) => shop.shopName,
                              onSelected:
                                  (shop) => setState(() => _selectedShop = shop),
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
                            ShopStaffStatusBadge(
                              isActive: _selectedShop?.isActive == true,
                            ),
                          ],
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
                        ...staffPermissionGroups.map(
                          (group) => StaffPermissionSection(
                            group: group,
                            values: _permissions[group.key] ?? const {},
                            onChanged:
                                (action, value) => _handlePermissionChanged(
                                  group.key,
                                  action,
                                  value,
                                ),
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.largeSpacing),
                        SecondaryButton.filled(
                          label: "shop_management.save_changes".tr(),
                          onPressed: _handleSubmit,
                          height: AppDimensions.smallHeightButton,
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  void _handlePermissionChanged(String group, String action, bool value) {
    setState(() {
      _permissions[group] = Map<String, bool>.from(_permissions[group] ?? {})
        ..[action] = value;
    });
  }

  void _handleSubmit() {
    final staff = widget.staff;
    final shopId = _selectedShop?.shopId;
    if (staff == null) return;
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
      permissions: _permissions.map(
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
