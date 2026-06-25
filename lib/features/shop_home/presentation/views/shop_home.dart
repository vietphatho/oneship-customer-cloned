import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_app_bar.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_brief_info.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_home_content_sections.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_home_feature_panel.dart';

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
  static const double _trackingInputHeight = 42;

  final ShopBloc _shopBloc = getIt.get();
  final PackagesBloc _packagesBloc = getIt.get();
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();
  final OrdersBloc _ordersBloc = getIt.get();
  final FinanceOverviewBloc _financeOverviewBloc = getIt.get();
  final FinanceReconciliationBloc _financeReconciliationBloc = getIt.get();
  final LocationServiceBloc _locationServiceBloc = getIt.get();

  final TextEditingController _trackingNumberCtrl = TextEditingController();

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
  void dispose() {
    _trackingNumberCtrl.dispose();
    super.dispose();
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

  Widget _buildTrackingInput(BuildContext context) {
    return Padding(
      padding: AppDimensions.smallPaddingHorizontal,
      child: Container(
        height: _trackingInputHeight,
        padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppDimensions.largeBorderRadius,
          border: Border.all(color: AppColors.neutral8),
          boxShadow: [PrimaryBoxShadows.defaultShadow],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: AppDimensions.xSmallIconSize,
            ),
            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
            Expanded(
              child: TextField(
                controller: _trackingNumberCtrl,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.characters,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: "input_tracking_number".tr(),
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.neutral5,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _onSearch(context),
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppDimensions.smallBorderRadius,
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.onPrimary,
                size: AppDimensions.smallIconSize,
              ),
            ),
          ],
        ),
      ),
    );
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
            child: _buildTrackingInput(context),
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

  void _onSearch(BuildContext context) {
    final trackingNumber = _trackingNumberCtrl.text.trim();

    if (trackingNumber.isEmpty) {
      return;
    }

    _orderTrackingBloc.search(trackingNumber);
    _locationServiceBloc.getCurrentLocation();

    context.push(RouteName.orderTrackingPage);
  }
}
