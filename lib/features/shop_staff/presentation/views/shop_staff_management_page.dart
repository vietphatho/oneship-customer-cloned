import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_entity.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_bloc.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_state.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_card.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_filter_panel.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_management_header.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_shop_selector.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ShopStaffManagementPage extends StatefulWidget {
  const ShopStaffManagementPage({super.key});

  @override
  State<ShopStaffManagementPage> createState() =>
      _ShopStaffManagementPageState();
}

class _ShopStaffManagementPageState extends State<ShopStaffManagementPage> {
  final RefreshController _refreshController = RefreshController();
  final ShopBloc _shopBloc = getIt.get();
  final ShopStaffBloc _shopStaffBloc = getIt.get();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoadingMore = false;

  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    final currentShop = _shopBloc.state.currentShop;
    if (currentShop != null) {
      _shopStaffBloc.init(currentShop);
    } else {
      _shopStaffBloc.refresh();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PrimaryAppBar(
        title: "shop_management.staff_title".tr(),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.search,
              color: AppColors.neutral2,
            ),
            tooltip: 'search'.tr(),
            onPressed: () {
              // TODO: implement staff search
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: AppColors.neutral2,
            ),
            tooltip: 'filter'.tr(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ShopStaffShopSelector(),
                      ShopStaffFilterPanel(
                        nameController: _nameController,
                        emailController: _emailController,
                        selectedStatus: _selectedStatus,
                        onStatusSelected: (value) {
                          _selectedStatus = value;
                        },
                        onApply: () {
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        onClear: () {
                          _clearFilters();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ShopBloc, ShopState>(
            bloc: _shopBloc,
            listenWhen: (previous, current) =>
                previous.currentShop != current.currentShop,
            listener: _handleCurrentShopChanged,
          ),
          BlocListener<ShopStaffBloc, ShopStaffState>(
            bloc: _shopStaffBloc,
            listenWhen: (previous, current) =>
                previous.staffsResource != current.staffsResource,
            listener: _handleStaffsResourceChanged,
          ),
          BlocListener<ShopStaffBloc, ShopStaffState>(
            bloc: _shopStaffBloc,
            listenWhen: (previous, current) =>
                previous.toggleDisableResource != current.toggleDisableResource,
            listener: _handleToggleDisableChanged,
          ),
        ],
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<ShopStaffBloc, ShopStaffState>(
            bloc: _shopStaffBloc,
            builder: (context, state) {
              final isInitialLoading =
                  state.staffsResource.state == Result.loading &&
                  state.staffs.isEmpty;
              final activeCount = state.staffs
                  .where((staff) => staff.isActive)
                  .length;
              final lockedCount = state.staffs.length - activeCount;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.mediumSpacing,
                      AppDimensions.xSmallSpacing,
                      AppDimensions.mediumSpacing,
                      AppDimensions.xSmallSpacing,
                    ),
                    child: Column(
                      children: [
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        ShopStaffStats(
                          total: state.total,
                          active: activeCount,
                          locked: lockedCount,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryActionButton(
                            label: 'shop_management.staff_add'.tr(),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            height: AppDimensions.mediumHeightButton,
                            onPressed: () =>
                                context.push(RouteName.createShopStaffPage),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isInitialLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryRefreshabelListView(
                            controller: _refreshController,
                            enablePullDown: true,
                            enablePullUp: state.hasMoreData,
                            onRefresh: () {
                              _isLoadingMore = false;
                              _shopStaffBloc.refresh();
                            },
                            onLoading: () {
                              _isLoadingMore = true;
                              _shopStaffBloc.loadMore();
                            },
                            padding: const EdgeInsets.fromLTRB(
                              AppDimensions.mediumSpacing,
                              0,
                              AppDimensions.mediumSpacing,
                              AppDimensions.safeBottomSpacing,
                            ),
                            itemCount: state.staffs.length,
                            separatorBuilder: (context, index) =>
                                AppSpacing.vertical(
                                  AppDimensions.xSmallSpacing,
                                ),
                            itemBuilder: (context, index) {
                              return ShopStaffCard(
                                staff: state.staffs[index],
                                onViewDetails: () => _openStaffDetail(
                                  context,
                                  state.staffs[index],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _applyFilters() {
    _isLoadingMore = false;
    _shopStaffBloc.filterStaffs(
      displayName: _nameController.text,
      userEmail: _emailController.text,
      userStatus: _selectedStatus == StaffStatusFilter.all
          ? null
          : _selectedStatus,
    );
  }

  void _clearFilters() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _selectedStatus = null;
    });
    _isLoadingMore = false;
    _shopStaffBloc.filterStaffs();
  }

  void _handleCurrentShopChanged(BuildContext context, ShopState state) {
    final currentShop = state.currentShop;
    if (currentShop != null) {
      _shopStaffBloc.init(currentShop);
    } else {
      _shopStaffBloc.refresh();
    }
  }

  void _openStaffDetail(BuildContext context, ShopStaffEntity staff) {
    _shopStaffBloc.fetchDetail(shopId: staff.shopId, staffId: staff.staffId);
    context.push(RouteName.shopStaffDetailPage);
  }

  void _handleStaffsResourceChanged(
    BuildContext context,
    ShopStaffState state,
  ) {
    switch (state.staffsResource.state) {
      case Result.loading:
        break;
      case Result.success:
        if (_isLoadingMore) {
          _refreshController.loadComplete();
          if (!state.hasMoreData) {
            _refreshController.loadNoData();
          }
        } else {
          _refreshController.refreshCompleted();
          _refreshController.resetNoData();
        }
        _isLoadingMore = false;
        break;
      case Result.error:
        if (_isLoadingMore) {
          _refreshController.loadFailed();
        } else {
          _refreshController.refreshFailed();
        }
        _isLoadingMore = false;
        break;
    }
  }

  void _handleToggleDisableChanged(BuildContext context, ShopStaffState state) {
    switch (state.toggleDisableResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.toggleDisableResource.message,
        );
        break;
    }
  }

}
