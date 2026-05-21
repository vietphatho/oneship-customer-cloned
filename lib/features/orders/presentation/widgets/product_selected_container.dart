import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/selected_product_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_state.dart';

class ProductSelectedContainer extends StatefulWidget {
  const ProductSelectedContainer({super.key});

  @override
  State<ProductSelectedContainer> createState() =>
      _ProductSelectedContainerState();
}

class _ProductSelectedContainerState extends State<ProductSelectedContainer> {
  final ProductBloc _productBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: PrimaryText(
                "product".tr(),
                style: AppTextStyles.titleSmall,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: PrimaryText(
                  "price".tr(),
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: PrimaryText(
                  "quantity".tr(),
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: PrimaryText(
                  "total_amount".tr(),
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ),
          ],
        ),

        AppSpacing.vertical(AppDimensions.xxSmallSpacing),

        BlocBuilder<ProductBloc, ProductState>(
          bloc: _productBloc,
          buildWhen:
              (pre, cur) =>
                  pre.productsListSelected != cur.productsListSelected,
          builder: (context, state) {
            return Column(
              children:
                  state.productsListSelected
                      .map((product) => _productSelectedItem(product))
                      .toList(),
            );
          },
        ),

        AppSpacing.vertical(AppDimensions.smallSpacing),

        Divider(height: 1.5, color: AppColors.neutral8),

        AppSpacing.vertical(AppDimensions.xSmallSpacing),

        Row(
          children: [
            Expanded(
              flex: 3,
              child: PrimaryText(
                "total".tr(),
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: PrimaryText(
                  "-",
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            BlocBuilder<ProductBloc, ProductState>(
              bloc: _productBloc,
              buildWhen:
                  (pre, cur) =>
                      pre.productsListSelected != cur.productsListSelected,
              builder: (context, state) {
                return Expanded(
                  flex: 3,
                  child: Center(
                    child: PrimaryText(
                      state.getCalculatedTotalQuantity().toString(),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),

            BlocBuilder<ProductBloc, ProductState>(
              bloc: _productBloc,
              buildWhen:
                  (pre, cur) =>
                      pre.productsListSelected != cur.productsListSelected,
              builder: (context, state) {
                return Expanded(
                  flex: 2,
                  child: Center(
                    child: PrimaryText(
                      Utils.formatCurrencyWithUnit(
                        state.getCalculatedTotalAmount(),
                      ),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _productSelectedItem(SelectedProductEntity product) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                product.name,
                style: AppTextStyles.bodyMedium,
              ),
              PrimaryText(product.sku, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: PrimaryText(
              Utils.formatCurrencyWithUnit(product.price),
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    if (product.quantity <= 1) {
                      PrimaryDialog.showQuestionDialog(
                        context,
                        title: 'delete_this_product',
                        onPositiveTapped: () {
                          _productBloc.updateProductSelectedQty(
                            sku: product.sku,
                            actionType: CreateOrderProductAction.decrement,
                          );
                        },
                      );
                    } else {
                      _productBloc.updateProductSelectedQty(
                        sku: product.sku,
                        actionType: CreateOrderProductAction.decrement,
                      );
                    }
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.remove, size: 16, color: Colors.white),
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                PrimaryText(
                  product.quantity.toString(),
                  style: AppTextStyles.bodyMedium,
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                InkWell(
                  onTap: () {
                    _productBloc.updateProductSelectedQty(
                      sku: product.sku,
                      actionType: CreateOrderProductAction.increment,
                    );
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: PrimaryText(
              Utils.formatCurrencyWithUnit(product.calculatedTotalAmount),
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
