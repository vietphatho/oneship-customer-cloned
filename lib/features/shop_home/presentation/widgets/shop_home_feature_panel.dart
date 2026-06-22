import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_home_feature_button.dart';

class ShopHomeFeaturePanel extends StatelessWidget {
  const ShopHomeFeaturePanel({super.key});

  static const int _itemsPerRow = 4;

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen: (pre, cur) =>
          cur.currentShop?.shopType != pre.currentShop?.shopType,
      builder: (context, state) {
        return _FeaturePanelContent(features: _features(state));
      },
    );
  }

  static List<ShopHomeFeature> _features(ShopState state) {
    final features = List<ShopHomeFeature>.from(ShopHomeFeature.values);

    if (state.currentShop?.shopType != ShopType.hospital) {
      features.removeWhere((e) => e == ShopHomeFeature.scanPatientCode);
    }

    return features;
  }
}

class _FeaturePanelContent extends StatelessWidget {
  const _FeaturePanelContent({required this.features});

  final List<ShopHomeFeature> features;

  @override
  Widget build(BuildContext context) {
    return PrimaryPanel(
      padding: AppDimensions.xSmallPaddingAll,
      borderRadius: AppDimensions.largeBorderRadius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              constraints.maxWidth / ShopHomeFeaturePanel._itemsPerRow;

          return Wrap(
            runSpacing: AppDimensions.xSmallSpacing,
            children: features
                .map(
                  (feature) => SizedBox(
                    width: itemWidth,
                    child: ShopHomeFeatureButton(feature: feature),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
