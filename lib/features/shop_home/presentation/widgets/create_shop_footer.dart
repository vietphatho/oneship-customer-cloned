import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/components/tertiary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class CreateShopFooter extends StatelessWidget {
  const CreateShopFooter({
    super.key,
    required this.shopBloc,
    required this.onSubmit,
  });

  final ShopBloc shopBloc;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.mediumSpacing,
          AppDimensions.smallSpacing,
          AppDimensions.mediumSpacing,
          AppDimensions.mediumSpacing,
        ),
        child: BlocBuilder<ShopBloc, ShopState>(
          bloc: shopBloc,
          buildWhen:
              (previous, current) =>
                  previous.createShopResource != current.createShopResource,
          builder: (context, shopState) {
            final isSubmitting =
                shopState.createShopResource.state == Result.loading;

            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TertiaryButton.filled(
                    label: 'cancel'.tr(),
                    onPressed: isSubmitting ? null : () => context.pop(),
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.xxxLargeSpacing),
                Expanded(
                  flex: 3,
                  child: SecondaryButton.filled(
                    label: isSubmitting ? 'handling'.tr() : 'create_shop'.tr(),
                    onPressed: isSubmitting ? null : onSubmit,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
