import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_selected_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class ProductSelectedContainer extends StatefulWidget {
  const ProductSelectedContainer({super.key});

  @override
  State<ProductSelectedContainer> createState() =>
      _ProductSelectedContainerState();
}

class _ProductSelectedContainerState extends State<ProductSelectedContainer> {
  final CreateOrderBloc _createOrderBloc = getIt.get();

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

        BlocBuilder<CreateOrderBloc, CreateOrderState>(
          bloc: _createOrderBloc,
          buildWhen: (_, current) => current is CreateOrderProductChangedState,
          builder: (context, state) {
            return Column(
              children:
                  state.productEntitySelected
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
            BlocBuilder<CreateOrderBloc, CreateOrderState>(
              bloc: _createOrderBloc,
              buildWhen:
                  (_, current) => current is CreateOrderProductChangedState,
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

            BlocBuilder<CreateOrderBloc, CreateOrderState>(
              bloc: _createOrderBloc,
              buildWhen:
                  (_, current) => current is CreateOrderProductChangedState,
              builder: (context, state) {
                return Expanded(
                  flex: 2,
                  child: Center(
                    child: PrimaryText(
                      Utils.formatCurrency(state.getCalculatedTotalAmount()),
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

  Widget _productSelectedItem(ProductEntitySelected product) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                product.product.productName,
                style: AppTextStyles.bodyMedium,
              ),
              PrimaryText(
                product.product.skuCode,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: PrimaryText(
              Utils.formatCurrency(product.product.price),
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
                          _createOrderBloc.updateProductQuantity(
                            product.product.skuCode,
                            ActionType.decrement,
                          );
                        },
                      );
                    } else {
                      _createOrderBloc.updateProductQuantity(
                        product.product.skuCode,
                        ActionType.decrement,
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
                    _createOrderBloc.updateProductQuantity(
                      product.product.skuCode,
                      ActionType.increment,
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
              Utils.formatCurrency(product.calculatedTotalAmount),
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
