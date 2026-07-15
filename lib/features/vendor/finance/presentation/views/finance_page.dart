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
import 'package:oneship_customer/features/auth/presentation/views/verify_secondary_password_page.dart';
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
              return VerifySecondaryPasswordPage(onCallback: _loadFinance);
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
              children: [
                VendorFinanceHeaderFilters(
                  startDate: state.startDate,
                  endDate: state.endDate,
                  selectedFilter: state.financeFilter,
                  onShopTap: () {},
                  onDateTap: () => _selectDateRange(state),
                  onFilterTap: (filter) => _selectQuickFilter(state, filter),
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
}
