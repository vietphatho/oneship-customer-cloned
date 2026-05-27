import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopSelectionButton extends StatelessWidget {
  const ShopSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return PrimaryAnimatedPressableWidget(
      onTap: () {
        context.push(RouteName.shopSelectionPage);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.smallSpacing,
          vertical: AppDimensions.xxSmallSpacing,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.largeBorderRadius,
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<ShopBloc, ShopState>(
                bloc: shopBloc,
                buildWhen: (previous, current) =>
                    previous.briefShopsResource != current.briefShopsResource ||
                    previous.currentShop != current.currentShop,
                builder: (context, state) {
                  return PrimaryText(
                    (state.currentShop?.shopName ?? 'select_shop').tr(),
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMedium,
                    color: AppColors.primary,
                  );
                },
              ),
            ),
            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: AppDimensions.xSmallIconSize,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}