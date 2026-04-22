import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_app_bar.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_brief_info.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  final ShopBloc _shopBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    // _shopBloc.init(shopId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [BlocListener(bloc: _shopBloc, listener: _handleListener)],
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
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 1,
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

  void _handleListener(BuildContext context, ShopState state) {}
}

class ShopHomeFeatureButton extends StatelessWidget {
  const ShopHomeFeatureButton({super.key, required this.feature});

  final ShopHomeFeature feature;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: () {
        context.push(feature.routeName);
      },
      child: PrimaryCard(
        child: Column(
          children: [
            PrimaryText(feature.name, overflow: TextOverflow.ellipsis),
            Icon(Icons.add_box_rounded, size: 32),
          ],
        ),
      ),
    );
  }
}
