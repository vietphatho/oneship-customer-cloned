import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dropdown.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopStaffShopSelector extends StatelessWidget {
  const ShopStaffShopSelector({
    super.key,
    required this.shopBloc,
    required this.onSelected,
  });

  final ShopBloc shopBloc;
  final ValueChanged<BriefShopEntity?> onSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen:
          (previous, current) =>
              previous.briefShopsResource != current.briefShopsResource ||
              previous.currentShop != current.currentShop,
      builder: (context, state) {
        final shops = state.briefShopsResource.data?.data ?? const [];

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.mediumSpacing,
            0,
            AppDimensions.mediumSpacing,
            AppDimensions.xSmallSpacing,
          ),
          child: PrimaryDropdown<BriefShopEntity>(
            key: ValueKey(state.currentShop?.shopId),
            label: "shop_management.staff_select_shop".tr(),
            hintText: "select".tr(),
            menu: shops,
            initialValue:
                shops.contains(state.currentShop) ? state.currentShop : null,
            toLabel: (shop) => shop.shopName,
            onSelected: onSelected,
          ),
        );
      },
    );
  }
}
