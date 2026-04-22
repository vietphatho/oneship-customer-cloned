import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_brief_info.dart';
import 'package:oneship_customer/features/shop_master/presentation/widgets/shop_master_app_bar.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShopMasterAppBar(),
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
              (context, index) =>
                  ShopHomeFeatureButton(feature: ShopHomeFeature.values[index]),
        ),
      ],
    );
  }
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
