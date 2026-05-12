import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
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
  final ShopBloc _shopBloc = getIt.get();
  final PackagesBloc _packagesBloc = getIt.get();
  final FinanceOverviewBloc _financeOverviewBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    // _shopBloc.init(shopId);
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
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: AppColors.shopHomeGradBg),
          ),
          Column(
            children: [
              const ShopAppBar(),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              const ShopBriefInfo(),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // childAspectRatio: 2 / 1,
                  mainAxisSpacing: AppDimensions.smallSpacing,
                  crossAxisSpacing: AppDimensions.smallSpacing,
                ),
                itemCount: ShopHomeFeature.values.length,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.mediumSpacing,
                  vertical: AppDimensions.smallSpacing,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder:
                    (context, index) => ShopHomeFeatureButton(
                      feature: ShopHomeFeature.values[index],
                    ),
              ),
            ],
          ),
        ],
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
    }
  }
}
