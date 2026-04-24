import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopSelectionButton extends StatelessWidget {
  const ShopSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen:
          (previous, current) =>
              previous.shopsResource != current.shopsResource ||
              previous.currentShop != current.currentShop,
      builder: (context, state) {
        final shops = state.shops;
        if (shops.isEmpty || state.currentShop == null) {
          return const SizedBox.shrink();
        }

        final selectedShop =
            shops.contains(state.currentShop) ? state.currentShop : null;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.primary,
              width: AppDimensions.smallBorderStroke,
            ),
            borderRadius: AppDimensions.largeBorderRadius,
          ),
          child: DropdownButton<ShopEntity>(
            isExpanded: true,
            items:
                shops
                    .map(
                      (e) => DropdownMenuItem<ShopEntity>(
                        value: e,
                        child: PrimaryText(
                          e.shopName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
            value: selectedShop,
            underline: const SizedBox(),
            onChanged: (_) {},
          ),
        );
      },
    );
  }
}
