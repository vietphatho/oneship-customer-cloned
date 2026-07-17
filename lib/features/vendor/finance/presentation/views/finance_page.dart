import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_overview_state.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/views/finance_overview_tab_view.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/views/finance_reconciliation_tab_view.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/views/reconciliation_cycle_page.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/widgets/finance_header_filters.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/widgets/finance_tab_bar.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/widgets/vendor_second_password_required_view.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';

class VendorFinancePage extends StatefulWidget {
  const VendorFinancePage({super.key});

  @override
  State<VendorFinancePage> createState() => _VendorFinancePageState();
}

class _VendorFinancePageState extends State<VendorFinancePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  final VendorFinanceOverviewBloc _vendorFinanceOverviewBloc = getIt.get();
  final VendorFinanceReconciliationBloc _vendorFinanceReconciliationBloc = getIt
      .get();
  final VendorProfileBloc _vendorProfileBloc = getIt.get();
  final AuthBloc _authBloc = getIt.get();
  bool _isCreateSecondPasswordRouteOpen = false;
  bool _isVerifySecondPasswordRouteOpen = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: VendorFinanceSubFeature.values.length,
      vsync: this,
    );
    if (_hasSecondPassword) {
      _loadFinance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'statistics_title'.tr(),
        // actions: [
        //   BlocBuilder<VendorFinanceOverviewBloc, VendorFinanceOverviewState>(
        //     bloc: _vendorFinanceOverviewBloc,
        //     builder: (context, state) {
        //       if (state.isSecondPasswordRequired &&
        //           state.vendorFinancialData.state == Result.error) {
        //         return const SizedBox.shrink();
        //       }
        //       return const PrimaryIconButton(
        //         icon: Icon(Icons.notifications_none_rounded),
        //         badgeText: '3',
        //         size: 40,
        //         iconSize: 20,
        //         borderRadius: BorderRadius.all(Radius.circular(10)),
        //       );
        //     },
        //   ),
        //   const SizedBox(width: 16),
        // ],
      ),
      body: BlocConsumer<VendorFinanceOverviewBloc, VendorFinanceOverviewState>(
        bloc: _vendorFinanceOverviewBloc,
        listenWhen: (pre, cur) =>
            pre.vendorFinancialData.state != cur.vendorFinancialData.state,
        listener: _handleVendorFinanceOverviewListener,
        buildWhen: (pre, cur) =>
            pre.vendorFinancialData.state != cur.vendorFinancialData.state &&
            (cur.vendorFinancialData.state != Result.loading),
        builder: (context, state) {
          if (!_hasSecondPassword) {
            return VendorSecondPasswordRequiredView(
              onCreatePressed: _openCreateSecondPasswordFlow,
            );
          }

          if (state.vendorFinancialData.state == Result.error) {
            if (state.isSecondPasswordRequired) {
              return const SizedBox.shrink();
            }

            return PrimaryEmptyData(
              onRetry: () {
                _vendorFinanceOverviewBloc.fetchFinancialData(
                  filter: state.financeFilter,
                  startDate: state.startDate,
                  endDate: state.endDate,
                  userId: _currentUserId,
                  requestSource: VendorFinanceRequestSource.page,
                );
              },
            );
          }

          return DefaultTabController(
            length: VendorFinanceSubFeature.values.length,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VendorFinanceHeaderFilters(
                  startDate: state.startDate,
                  endDate: state.endDate,
                  selectedFilter: state.financeFilter,
                  onDateFilterTap: () => _openDateFilterSheet(state),
                ),
                VendorFinanceTabBar(controller: controller),
                Expanded(
                  child: TabBarView(
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      VendorFinanceOverviewTabView(),
                      VendorFinanceReconciliationTabView(),
                      ReconciliationCyclePage(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleVendorFinanceOverviewListener(
    BuildContext context,
    VendorFinanceOverviewState state,
  ) {
    switch (state.vendorFinancialData.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        if (state.requestSource == VendorFinanceRequestSource.filterDialog) {
          context.pop();
        }
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        if (state.requestSource == VendorFinanceRequestSource.filterDialog) {
          context.pop();
        }
        if (state.isSecondPasswordRequired) {
          _openVerifySecondPasswordFlow();
          break;
        }
        PrimaryDialog.showErrorDialog(
          context,
          message: state.vendorFinancialData.message,
        );
        break;
    }
  }

  Future<void> _selectDateRange(VendorFinanceOverviewState state) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTimeUtils.minDate,
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: state.startDate,
        end: state.endDate,
      ),
    );
    if (range == null) return;

    _vendorFinanceOverviewBloc.fetchFinancialData(
      filter: VendorFinanceFilter.selectDate,
      startDate: range.start,
      endDate: range.end,
      userId: _currentUserId,
      requestSource: VendorFinanceRequestSource.page,
    );
  }

  Future<void> _openDateFilterSheet(VendorFinanceOverviewState state) async {
    final filter = await showModalBottomSheet<VendorFinanceFilter>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _VendorFinanceDateFilterSheet(
        selectedFilter: state.financeFilter,
        startDate: state.startDate,
        endDate: state.endDate,
      ),
    );
    if (filter == null) return;

    if (filter == VendorFinanceFilter.selectDate) {
      await _selectDateRange(state);
      return;
    }

    _selectQuickFilter(state, filter);
  }

  void _selectQuickFilter(
    VendorFinanceOverviewState state,
    VendorFinanceFilter filter,
  ) {
    if (state.financeFilter == filter) return;

    _vendorFinanceOverviewBloc.fetchFinancialData(
      filter: filter,
      startDate: filter.getStartDate() ?? state.startDate,
      endDate: DateTime.now(),
      userId: _currentUserId,
      requestSource: VendorFinanceRequestSource.page,
    );
  }

  String get _currentUserId => _vendorProfileBloc.profile?.userId?.trim() ?? "";

  bool get _hasSecondPassword =>
      _authBloc.userProfile.hasSecondPassword == true;

  void _loadFinance() {
    _vendorFinanceOverviewBloc.init(
      userId: _currentUserId,
      requestSource: VendorFinanceRequestSource.page,
    );
    _vendorFinanceReconciliationBloc.initPeriods(userId: _currentUserId);
  }

  Future<void> _openCreateSecondPasswordFlow() async {
    if (_isCreateSecondPasswordRouteOpen) return;
    if (!mounted) return;

    _isCreateSecondPasswordRouteOpen = true;
    final isCreated = await context.push<bool>(
      RouteName.changeSecondaryPasswordPage,
    );
    _isCreateSecondPasswordRouteOpen = false;

    if (!mounted) return;
    if (isCreated == true || _hasSecondPassword) {
      _loadFinance();
      return;
    }

    setState(() {});
  }

  Future<void> _openVerifySecondPasswordFlow() async {
    if (_isVerifySecondPasswordRouteOpen) return;
    if (!mounted) return;

    _isVerifySecondPasswordRouteOpen = true;
    final isVerified = await context.push<bool>(
      RouteName.vendorFinanceVerifySecondaryPasswordPage,
    );
    _isVerifySecondPasswordRouteOpen = false;

    if (!mounted) return;
    if (isVerified == true) {
      _loadFinance();
    }
  }
}

class _VendorFinanceDateFilterSheet extends StatelessWidget {
  const _VendorFinanceDateFilterSheet({
    required this.selectedFilter,
    required this.startDate,
    required this.endDate,
  });

  final VendorFinanceFilter selectedFilter;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    const filters = [
      VendorFinanceFilter.oneDay,
      VendorFinanceFilter.sevenDay,
      VendorFinanceFilter.thirtyDay,
      VendorFinanceFilter.selectDate,
    ];

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.largeRadius),
            topRight: Radius.circular(AppDimensions.largeRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.mediumSpacing),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'select_date'.tr(),
                    style: AppTextStyles.titleSmall,
                  ),
                ),
                Flexible(
                  child: Text(
                    _dateRangeText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.bodyXXSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.smallSpacing),
            ...filters.map(
              (filter) => _DateFilterOptionTile(
                filter: filter,
                selected: selectedFilter == filter,
                onTap: () => Navigator.of(context).pop(filter),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _dateRangeText =>
      '${DateTimeUtils.formatDateFromDT(startDate)} - ${DateTimeUtils.formatDateFromDT(endDate)}';
}

class _DateFilterOptionTile extends StatelessWidget {
  const _DateFilterOptionTile({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final VendorFinanceFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.blue950;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.smallSpacing,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withAlpha(18) : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _filterLabel(filter),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelXSmall.copyWith(color: color),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: AppDimensions.smallIconSize,
              ),
          ],
        ),
      ),
    );
  }

  String _filterLabel(VendorFinanceFilter filter) {
    return switch (filter) {
      VendorFinanceFilter.oneDay => 'last_24_hours'.tr(),
      VendorFinanceFilter.sevenDay => 'last_7_days'.tr(),
      VendorFinanceFilter.thirtyDay => 'last_30_days'.tr(),
      VendorFinanceFilter.selectDate => 'select_date'.tr(),
    };
  }
}
