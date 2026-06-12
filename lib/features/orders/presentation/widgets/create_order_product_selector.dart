import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/product_selected_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class CreateOrderProductSection extends StatelessWidget {
  const CreateOrderProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CreateOrderProductSelector(),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        const ProductSelectedContainer(),
      ],
    );
  }
}

class CreateOrderProductSelector extends StatefulWidget {
  const CreateOrderProductSelector({super.key});

  @override
  State<CreateOrderProductSelector> createState() =>
      _CreateOrderProductSelectorState();
}

class _CreateOrderProductSelectorState
    extends State<CreateOrderProductSelector> {
  final ProductBloc _productBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _productBloc.fetchProductsList(_shopBloc.state.currentShop?.shopId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteName.productPage),
      child: BlocSelector<ProductBloc, ProductState, int>(
        bloc: _productBloc,
        selector: (state) => state.selectedCount,
        builder: (context, selectedCount) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: AppDimensions.xSmallSpacing,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.neutral8),
              borderRadius: AppDimensions.largeBorderRadius,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_create_order_product_box.svg",
                  width: AppDimensions.smallIconSize,
                  height: AppDimensions.smallIconSize,
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                Expanded(
                  child: PrimaryText(
                    selectedCount == 0
                        ? "select_product".tr()
                        : "$selectedCount ${"product_selected".tr()}",
                    style: AppTextStyles.bodySmall,
                    color:
                        selectedCount == 0
                            ? AppColors.neutral6
                            : AppColors.neutral2,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: AppDimensions.smallIconSize,
                  color: AppColors.neutral5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
