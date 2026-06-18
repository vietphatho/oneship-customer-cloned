import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopStaffShopSelector extends StatelessWidget {
  const ShopStaffShopSelector({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
  final ShopBloc shopBloc = getIt.get();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        0,
        AppDimensions.mediumSpacing,
        AppDimensions.mediumSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            "shop_management.staff_select_shop".tr(),
            style: AppTextStyles.labelMedium,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          PrimaryAnimatedPressableWidget(
            onTap: () {
              context.push(RouteName.shopSelectionPage);
            },
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.smallSpacing),
              decoration: BoxDecoration(
                borderRadius: AppDimensions.largeBorderRadius,
                border: Border.all(color: AppColors.neutral7),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<ShopBloc, ShopState>(
                      bloc: shopBloc,
                      buildWhen: (previous, current) =>
                          previous.briefShopsResource !=
                              current.briefShopsResource ||
                          previous.currentShop != current.currentShop,
                      builder: (context, state) {
                        return PrimaryText(
                          (state.currentShop?.shopName ?? 'select_shop').tr(),
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium,
                        );
                      },
                    ),
                  ),
                  AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppDimensions.xSmallIconSize,
                    color: AppColors.neutral7,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
