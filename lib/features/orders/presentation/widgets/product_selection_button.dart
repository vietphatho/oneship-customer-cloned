import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class ProductSelectionButton extends StatefulWidget {
  const ProductSelectionButton({super.key});

  @override
  State<ProductSelectionButton> createState() => _ProductSelectionButtonState();
}

class _ProductSelectionButtonState extends State<ProductSelectionButton> {
  final ProductBloc _productBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  @override
  void initState() {
    _productBloc.fetchProductsList(_shopBloc.state.currentShop?.shopId ?? "");
    super.initState();
  }

  void _openProductPage() {
    context.push(RouteName.productPage);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openProductPage,
      child: AbsorbPointer(
        child: BlocSelector<ProductBloc, ProductState, int>(
          bloc: _productBloc,
          selector: (state) => state.selectedCount,
          builder: (context, state) {
            return PrimaryTextField(
              label: "product".tr(),
              hintText: "$state ${"product_selected".tr()}",
              suffixIcon: Icon(
                Icons.add_circle,
                size: 24,
                color: AppColors.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}
