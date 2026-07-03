import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_app_bar.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_brief_info.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_home_content_sections.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_home_feature_panel.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/tracking_search_input.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  static const double _heroHeight = 230;
  static const double _briefInfoHeight = 84;
  static const double _headerContentSpacing = 8;
  static const double _headerContentHeight =
      _heroHeight + _headerContentSpacing + _briefInfoHeight;

  final ShopBloc _shopBloc = getIt.get();
  final PackagesBloc _packagesBloc = getIt.get();
  final OrdersBloc _ordersBloc = getIt.get();
  final FinanceOverviewBloc _financeOverviewBloc = getIt.get();
  final FinanceReconciliationBloc _financeReconciliationBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    // _shopBloc.init(shopId);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!mounted) return;
    //   CustomerCreditLimitDialog.show(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ShopBloc, ShopState>(
          bloc: _shopBloc,
          listenWhen: (pre, cur) => cur.currentShop != pre.currentShop,
          listener: _listenCurrentShopChanged,
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: AppDimensions.safeBottomSpacing,
          ),
          child: Column(
            children: [
              _buildHeaderWithBriefInfo(context),
              AppSpacing.vertical(AppDimensions.xSmallSpacing),
              Padding(
                padding: AppDimensions.smallPaddingHorizontal,
                child: Column(
                  children: [
                    const ShopHomeFeaturePanel(),
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
                    const ShopHomePromotionBanner(),
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
                    const ShopHomeOfferSection(),
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                    const ShopHomeNewsSection(),
                    AppSpacing.vertical(AppDimensions.xxLargeSpacing),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listenCurrentShopChanged(BuildContext context, ShopState state) {
    if (state.currentShop != null) {
      _packagesBloc.init(state.currentShop!);
      _financeOverviewBloc.init(
        shopId: state.currentShop?.shopId ?? "",
        requestSource: FinanceRequestSource.page,
      );
      _financeReconciliationBloc.initPeriods(
        shopId: state.currentShop?.shopId ?? "",
      );
      _ordersBloc.init(state.currentShop?.shopId ?? "");
    }
  }

  Widget _buildHeroHeader(BuildContext context) {
    return SizedBox(
      height: _heroHeight,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.shopHomeGradBg),
            ),
          ),
          Positioned(
            left: -64,
            right: -64,
            bottom: 0,
            child: Image.asset(
              ImagePath.shopHomeHeaderOzoShipGenerated,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 72,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCCFFFFFF), Colors.white],
                  stops: [0, 0.72, 1],
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: ShopAppBar(useDarkContent: true),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: AppDimensions.xSmallSpacing,
            child: const TrackingSearchInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWithBriefInfo(BuildContext context) {
    return SizedBox(
      height: _headerContentHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildHeroHeader(context),
          const Positioned(
            left: 0,
            right: 0,
            top: _heroHeight + _headerContentSpacing,
            child: ShopBriefInfo(),
          ),
        ],
      ),
    );
  }
}
