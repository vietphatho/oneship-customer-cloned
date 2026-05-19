import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/primary_radio_group.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/views/verify_secondary_password_page.dart';
import 'package:oneship_customer/features/finance/data/enum.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_state.dart';
import 'package:oneship_customer/features/finance/presentation/views/finance_overview_tab_view.dart';
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
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "finance".tr(),
        actions: [
          BlocBuilder<FinanceOverviewBloc, FinanceOverviewState>(
            bloc: _financeOverviewBloc,
            builder: (context, state) {
              if (state.isSecondPasswordRequired) {
                return Container();
              }
              return _FinanceFilterWidget();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<FinanceOverviewBloc, FinanceOverviewState>(
          bloc: _financeOverviewBloc,
          listenWhen:
              (pre, cur) =>
                  pre.shopFinancialData.state != cur.shopFinancialData.state,
          listener: _handleFinanceOverviewListener,
          buildWhen:
              (pre, cur) =>
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
                  FinanceTabBar(controller: controller),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: [FinanceOverviewTabView(), Container()],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
}

class _FinanceFilterWidget extends StatelessWidget {
  const _FinanceFilterWidget();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        PrimaryDialog.showCustomDialog(
          context,
          child: _SelectDateFilterSession(),
        );
      },
      icon: Icon(Icons.filter_alt),
    );
  }
}

class _SelectDateFilterSession extends StatefulWidget {
  const _SelectDateFilterSession();

  @override
  State<_SelectDateFilterSession> createState() =>
      __SelectDateFilterSessionState();
}

class __SelectDateFilterSessionState extends State<_SelectDateFilterSession> {
  final FinanceOverviewBloc _financeOverviewBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  late DateTime startDate;
  late DateTime endDate;
  late FinanceFilter currentFilter;

  @override
  void initState() {
    startDate = _financeOverviewBloc.state.startDate;
    endDate = _financeOverviewBloc.state.endDate;
    currentFilter = _financeOverviewBloc.state.financeFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText('filter'.tr(), style: AppTextStyles.titleXLarge),
        PrimaryRadioGroup<FinanceFilter>(
          options: FinanceFilter.values,
          value: currentFilter,
          displayLabel: (item) {
            return item.name.tr();
          },
          onChanged: (value) => _onChangedFinanceFilter(value),
        ),
        if (currentFilter == FinanceFilter.selectDate)
          GestureDetector(
            onTap: () {
              showDateRangePicker(
                context: context,
                firstDate: DateTimeUtils.minDate,
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(start: startDate, end: endDate),
              ).then((onValue) {
                if (onValue != null) {
                  setState(() {
                    startDate = onValue.start;
                    endDate = onValue.end;
                  });
                }
              });
            },
            child: PrimaryCard(
              child: PrimaryText(
                '${DateTimeUtils.formatDateFromDT(startDate)} - ${DateTimeUtils.formatDateFromDT(endDate)}',
              ),
            ),
          ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        Row(
          children: [
            Expanded(
              child: SecondaryButton.outlined(
                label: 'cancel'.tr(),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            Expanded(
              child: SecondaryButton.filled(
                label: 'confirm'.tr(),
                onPressed: () => _fetchFinancialData(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onChangedFinanceFilter(FinanceFilter value) {
    if (value != FinanceFilter.selectDate) {
      setState(() {
        currentFilter = value;
        startDate = value.getStartDate() ?? startDate;
        endDate = DateTime.now();
      });
    } else {
      showDateRangePicker(
        context: context,
        firstDate: DateTimeUtils.minDate,
        lastDate: DateTime.now(),
        initialDateRange: DateTimeRange(start: startDate, end: endDate),
      ).then((onValue) {
        if (onValue != null) {
          setState(() {
            currentFilter = value;
            startDate = onValue.start;
            endDate = onValue.end;
          });
        }
      });
    }
  }

  void _fetchFinancialData() async {
    _financeOverviewBloc.fetchFinancialData(
      filter: currentFilter,
      startDate: startDate,
      endDate: endDate,
      shopId: _shopBloc.state.currentShop?.shopId ?? "",
      requestSource: FinanceRequestSource.filterDialog,
    );
  }
}
