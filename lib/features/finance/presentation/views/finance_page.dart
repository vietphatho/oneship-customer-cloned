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
import 'package:oneship_customer/features/finance/presentation/widgets/finance_tab_bar.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

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
                _FinanceHeaderFilters(
                  shopName:
                      _shopBloc.state.currentShop?.shopName ?? 'your_shop'.tr(),
                  shopLogo: _shopBloc.state.currentShop?.shopLogo,
                  startDate: state.startDate,
                  endDate: state.endDate,
                  selectedFilter: state.financeFilter,
                  onShopTap: () => context.push(RouteName.shopSelectionPage),
                  onDateTap: () => _selectDateRange(state),
                  onFilterTap: (filter) => _selectQuickFilter(state, filter),
                ),
                FinanceTabBar(controller: controller),
                Expanded(
                  child: TabBarView(
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const FinanceOverviewTabView(),
                      FinanceReconciliationTabView(),
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

class _FinanceHeaderFilters extends StatelessWidget {
  const _FinanceHeaderFilters({
    required this.shopName,
    required this.shopLogo,
    required this.startDate,
    required this.endDate,
    required this.selectedFilter,
    required this.onShopTap,
    required this.onDateTap,
    required this.onFilterTap,
  });

  final String shopName;
  final String? shopLogo;
  final DateTime startDate;
  final DateTime endDate;
  final FinanceFilter selectedFilter;
  final VoidCallback onShopTap;
  final VoidCallback onDateTap;
  final ValueChanged<FinanceFilter> onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _HeaderFilterCard(
                  onTap: onShopTap,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary,
                        backgroundImage: shopLogo?.isNotEmpty == true
                            ? NetworkImage(shopLogo!)
                            : null,
                        child: shopLogo?.isNotEmpty == true
                            ? null
                            : const Text(
                                'OzoShip',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          shopName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const _HeaderSvgIcon(
                        asset: 'assets/icons/finance_chevron_down.svg',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    _HeaderFilterCard(
                      onTap: onDateTap,
                      height: 34,
                      child: Row(
                        children: [
                          const _HeaderSvgIcon(
                            asset: 'assets/icons/finance_calendar.svg',
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${DateTimeUtils.formatDateFromDT(startDate)} - ${DateTimeUtils.formatDateFromDT(endDate)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.grey600,
                              ),
                            ),
                          ),
                          const _HeaderSvgIcon(
                            asset: 'assets/icons/finance_chevron_down.svg',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    _QuickFilterBar(
                      selectedFilter: selectedFilter,
                      onFilterTap: onFilterTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickFilterBar extends StatelessWidget {
  const _QuickFilterBar({
    required this.selectedFilter,
    required this.onFilterTap,
  });

  final FinanceFilter selectedFilter;
  final ValueChanged<FinanceFilter> onFilterTap;

  @override
  Widget build(BuildContext context) {
    const filters = [
      FinanceFilter.oneDay,
      FinanceFilter.sevenDay,
      FinanceFilter.thirtyDay,
    ];

    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: filters.map((filter) {
          final selected = selectedFilter == filter;
          return Expanded(
            child: InkWell(
              onTap: () => onFilterTap(filter),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(38),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _filterLabel(filter),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.blue950,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(FinanceFilter filter) {
    return switch (filter) {
      FinanceFilter.oneDay => 'last_24_hours'.tr(),
      FinanceFilter.sevenDay => 'last_7_days'.tr(),
      FinanceFilter.thirtyDay => 'last_30_days'.tr(),
      FinanceFilter.selectDate => 'select_date'.tr(),
    };
  }
}

class _HeaderFilterCard extends StatelessWidget {
  const _HeaderFilterCard({
    required this.onTap,
    required this.child,
    this.height = 72,
  });

  final VoidCallback onTap;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _HeaderSvgIcon extends StatelessWidget {
  const _HeaderSvgIcon({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: 18,
      height: 18,
      colorFilter: const ColorFilter.mode(AppColors.grey600, BlendMode.srcIn),
    );
  }
}
