import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_app_bar.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_brief_info.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_home_feature_button.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  static const List<String> _banners = [ImagePath.customerHomeSlider1];

  final ShopBloc _shopBloc = getIt.get();
  final PackagesBloc _packagesBloc = getIt.get();
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();
  final FinanceOverviewBloc _financeOverviewBloc = getIt.get();
  final FinanceReconciliationBloc _financeReconciliationBloc = getIt.get();
  final TextEditingController _trackingNumberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _shopBloc.init(shopId);
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
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagePath.shopHomeBackground),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(
                    top: AppDimensions.shopHomeTopSpacing,
                  ),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  height: AppDimensions.xxLargeRadius,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.xxLargeRadius),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const ShopAppBar(),
                  AppSpacing.vertical(AppDimensions.xSmallSpacing),
                  _buildTrackingInput(context),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  const ShopBriefInfo(),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.76,
                      mainAxisSpacing: AppDimensions.smallSpacing,
                      crossAxisSpacing: AppDimensions.smallSpacing,
                    ),
                    itemCount: ShopHomeFeature.values.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.mediumSpacing,
                      vertical: AppDimensions.smallSpacing,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => ShopHomeFeatureButton(
                      feature: ShopHomeFeature.values[index],
                    ),
                  ),
                  _buildPromotionSlider(),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                ],
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
    }
  }

  Widget _buildTrackingInput(BuildContext context) {
    return Padding(
      padding: AppDimensions.mediumPaddingHorizontal,
      child: PrimaryTextField(
        controller: _trackingNumberCtrl,
        hintText: "input_tracking_number".tr(),
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.characters,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.primary,
          size: AppDimensions.smallIconSize,
        ),
        onFieldSubmitted: (_) => _onSearch(context),
      ),
    );
  }

  Widget _buildPromotionSlider() {
    return Padding(
      padding: AppDimensions.mediumPaddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            'Chương trình khuyến mãi',
            style: AppTextStyles.labelSmall,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          CarouselSlider(
            options: CarouselOptions(
              height: 120,
              autoPlay: true,
              enlargeCenterPage: false,
              viewportFraction: 1,
            ),
            items: _banners.map((banner) {
              return ClipRRect(
                borderRadius: AppDimensions.smallBorderRadius,
                child: Image.asset(
                  banner,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }).toList(),
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
    context.push(RouteName.orderTrackingPage);
  }
}
