import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/views/verify_secondary_password_page.dart';
import 'package:oneship_customer/features/finance/data/enum.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_state.dart';
import 'package:oneship_customer/features/finance/presentation/views/finance_overview_tab_view.dart';
import 'package:oneship_customer/features/finance/presentation/views/finance_reconciliation_tab_view.dart';
import 'package:oneship_customer/features/finance/presentation/views/reconciliation_cycle_page.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_header_filters.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_tab_bar.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  final FinanceOverviewBloc _financeOverviewBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: FinanceSubFeature.values.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'statistics_title'.tr(),
        actions: [
          BlocBuilder<FinanceOverviewBloc, FinanceOverviewState>(
            bloc: _financeOverviewBloc,
            builder: (context, state) {
              if (state.isSecondPasswordRequired &&
                  state.shopFinancialData.state == Result.error) {
                return const SizedBox.shrink();
              }
              return const PrimaryIconButton(
                icon: Icon(Icons.notifications_none_rounded),
                badgeText: '3',
                size: 40,
                iconSize: 20,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<FinanceOverviewBloc, FinanceOverviewState>(
        bloc: _financeOverviewBloc,
        listenWhen: (pre, cur) =>
            pre.shopFinancialData.state != cur.shopFinancialData.state,
        listener: _handleFinanceOverviewListener,
        buildWhen: (pre, cur) =>
            pre.shopFinancialData.state != cur.shopFinancialData.state &&
            (cur.shopFinancialData.state != Result.loading),
        builder: (context, state) {
          if (state.shopFinancialData.state == Result.error) {
            if (state.isSecondPasswordRequired) {
              return VerifySecondaryPasswordPage(
                onCallback: () {
                  _financeOverviewBloc.init(
                    shopId: _shopBloc.state.currentShop?.shopId ?? "",
                    requestSource: FinanceRequestSource.page,
                  );
                },
              );
            }

            return PrimaryEmptyData(
              onRetry: () {
                _financeOverviewBloc.fetchFinancialData(
                  filter: state.financeFilter,
                  startDate: state.startDate,
                  endDate: state.endDate,
                  shopId: _shopBloc.state.currentShop?.shopId ?? "",
                  requestSource: FinanceRequestSource.page,
                );
              },
            );
          }

          return DefaultTabController(
            length: FinanceSubFeature.values.length,
            child: Column(
              children: [
                FinanceHeaderFilters(
                  startDate: state.startDate,
                  endDate: state.endDate,
                  selectedFilter: state.financeFilter,
                  onShopTap: () => context.push(RouteName.shopSelectionPage),
                  onDateTap: () => _selectDateRange(state),
                  onFilterTap: (filter) => _selectQuickFilter(state, filter),
                ),
                FinanceTabBar(controller: controller),
                BlocBuilder<ShopBloc, ShopState>(
                  bloc: _shopBloc,
                  buildWhen: (previous, current) =>
                      previous.currentShop != current.currentShop,
                  builder: (context, state) {
                    return Expanded(
                      child: TabBarView(
                        controller: controller,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          FinanceOverviewTabView(),
                          FinanceReconciliationTabView(),
                          ReconciliationCyclePage(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleFinanceOverviewListener(
    BuildContext context,
    FinanceOverviewState state,
  ) {
    switch (state.shopFinancialData.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        if (state.requestSource == FinanceRequestSource.filterDialog) {
          context.pop();
        }
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        if (state.requestSource == FinanceRequestSource.filterDialog) {
          context.pop();
        }
        if (state.isSecondPasswordRequired) {
          break;
        }
        PrimaryDialog.showErrorDialog(
          context,
          message: state.shopFinancialData.message,
        );
        break;
    }
  }

  Future<void> _selectDateRange(FinanceOverviewState state) async {
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

    _financeOverviewBloc.fetchFinancialData(
      filter: FinanceFilter.selectDate,
      startDate: range.start,
      endDate: range.end,
      shopId: _shopBloc.state.currentShop?.shopId ?? "",
      requestSource: FinanceRequestSource.page,
    );
  }

  void _selectQuickFilter(FinanceOverviewState state, FinanceFilter filter) {
    if (state.financeFilter == filter) return;

    _financeOverviewBloc.fetchFinancialData(
      filter: filter,
      startDate: filter.getStartDate() ?? state.startDate,
      endDate: DateTime.now(),
      shopId: _shopBloc.state.currentShop?.shopId ?? "",
      requestSource: FinanceRequestSource.page,
    );
  }
}
