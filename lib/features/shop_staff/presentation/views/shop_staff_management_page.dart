import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_entity.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_bloc.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_state.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_add_footer.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_card.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_filter_panel.dart';
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
  bool _showFilters = false;
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
      appBar: PrimaryAppBar(
        title: "shop_management.staff_title".tr(),
        canPop: false,
        actions: [
          IconButton(
            onPressed: () => setState(() => _showFilters = !_showFilters),
            icon: const Icon(
              Icons.filter_alt,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ShopBloc, ShopState>(
            bloc: _shopBloc,
            listenWhen:
                (previous, current) =>
                    previous.currentShop != current.currentShop,
            listener: (context, state) {
              final currentShop = state.currentShop;
              if (currentShop != null) {
                _shopStaffBloc.init(currentShop);
              } else {
                _shopStaffBloc.refresh();
              }
            },
          ),
          BlocListener<ShopStaffBloc, ShopStaffState>(
            bloc: _shopStaffBloc,
            listenWhen:
                (previous, current) =>
                    previous.staffsResource != current.staffsResource,
            listener: _handleStaffsResourceChanged,
          ),
          BlocListener<ShopStaffBloc, ShopStaffState>(
            bloc: _shopStaffBloc,
            listenWhen:
                (previous, current) =>
                    previous.toggleDisableResource !=
                    current.toggleDisableResource,
            listener: _handleToggleDisableChanged,
          ),
        ],
        child: SafeArea(
          child: BlocBuilder<ShopStaffBloc, ShopStaffState>(
            bloc: _shopStaffBloc,
            builder: (context, state) {
              final isInitialLoading =
                  state.staffsResource.state == Result.loading &&
                  state.staffs.isEmpty;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.mediumSpacing,
                      AppDimensions.xxSmallSpacing,
                      AppDimensions.mediumSpacing,
                      AppDimensions.smallSpacing,
                    ),
                    child: Column(
                      children: [
                        PrimaryText(
                          "shop_management.staff_header".tr(),
                          style: AppTextStyles.titleMedium,
                          bold: true,
                        ),
                        AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
                        PrimaryText(
                          "shop_management.staff_subtitle".tr(
                            namedArgs: {'count': state.total.toString()},
                          ),
                          style: AppTextStyles.bodyMedium,
                          color: AppColors.neutral4,
                        ),
                      ],
                    ),
                  ),
                  if (_showFilters)
                    ShopStaffFilterPanel(
                      nameController: _nameController,
                      emailController: _emailController,
                      selectedStatus: _selectedStatus,
                      onStatusSelected:
                          (value) => setState(() => _selectedStatus = value),
                      onApply: _applyFilters,
                      onClear: _clearFilters,
                    ),
                  ShopStaffShopSelector(
                    shopBloc: _shopBloc,
                    onSelected: _handleShopSelected,
                  ),
                  Expanded(
                    child:
                        isInitialLoading
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
                              padding: EdgeInsets.fromLTRB(
                                AppDimensions.mediumSpacing,
                                0,
                                AppDimensions.mediumSpacing,
                                AppDimensions.smallSpacing,
                              ),
                              itemCount: state.staffs.length,
                              separatorBuilder:
                                  (context, index) => AppSpacing.vertical(
                                    AppDimensions.mediumSpacing,
                                  ),
                              itemBuilder: (context, index) {
                                return ShopStaffCard(
                                  index: index + 1,
                                  staff: state.staffs[index],
                                  onViewDetails:
                                      () => _openStaffDetail(
                                        context,
                                        state.staffs[index],
                                      ),
                                );
                              },
                            ),
                  ),
                  ShopStaffAddFooter(
                    onPressed: () => context.push(RouteName.createShopStaffPage),
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
      userStatus:
          _selectedStatus == StaffStatusFilter.all ? null : _selectedStatus,
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

  void _handleShopSelected(BriefShopEntity? shop) {
    if (shop == null) return;
    _isLoadingMore = false;
    _shopBloc.changeShop(shop);
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

  void _handleToggleDisableChanged(
    BuildContext context,
    ShopStaffState state,
  ) {
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
