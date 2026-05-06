import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';

class OrderDetailProductsListTabView extends StatelessWidget {
  const OrderDetailProductsListTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersBloc _ordersBloc = getIt.get();

    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      builder: (context, state) {
        var products = state.orderDetailResource.data?.items ?? [];
        if (products.isEmpty) {
          return const PrimaryEmptyData();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
          ),
          child: Column(
            children: [
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              _buildTitleRow(),
              const Divider(),
              ...products.map((item) => _InfoRow(product: item)),
              const Divider(),
              _buildSummaryRow(state.orderDetailResource.data!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: PrimaryText(
              "product_name".tr(),
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: PrimaryText(
              "price".tr(),
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: PrimaryText(
              "quantity".tr(),
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: PrimaryText(
              "total".tr(),
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(OrderDetailEntity detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: PrimaryText(
              "total".tr(),
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            flex: 2,
            child: PrimaryText(
              "",
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: PrimaryText(
              detail.totalProductQty.toString(),
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            flex: 2,
            child: PrimaryText(
              Utils.formatCurrencyWithUnit(detail.totalProductPrice),
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({super.key, required this.product});

  final OrderDetailProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: PrimaryText(
              product.productName,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: PrimaryText(
              Utils.formatCurrencyWithUnit(product.unitPrice),
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: PrimaryText(
              product.quantity.toString(),
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: PrimaryText(
              Utils.formatCurrencyWithUnit(
                product.unitPrice * product.quantity - product.discountAmount,
              ),
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
