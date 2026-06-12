import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class CreateOrderDeliveryServiceSelector extends StatelessWidget {
  CreateOrderDeliveryServiceSelector({super.key});

  final CreateOrderBloc _createOrderBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PrimaryText(
                  "delivery_service_type".tr(),
                  style: AppTextStyles.bodySmall,
                  bold: true,
                ),
                const PrimaryText(" *", color: AppColors.primary),
              ],
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            Row(
              children:
                  _shopBloc.state.shippingServices
                      .map(
                        (service) => Expanded(
                          child: _serviceCard(
                            service,
                            selected: state.draftRequest.serviceConfig == service,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _serviceCard(
    ShippingServiceConfigEntity service, {
    required bool selected,
  }) {
    final isExpress =
        service.serviceCode.toLowerCase().contains("express") ||
        service.serviceLabel.toLowerCase().contains("hỏa");
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.xSmallSpacing),
      child: InkWell(
        borderRadius: AppDimensions.largeBorderRadius,
        onTap: () => _createOrderBloc.changeOrderInfo(serviceConfig: service),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight : Colors.white,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.neutral8,
            ),
            borderRadius: AppDimensions.largeBorderRadius,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                isExpress
                    ? "assets/icons/icon_delivery_express.svg"
                    : "assets/icons/icon_delivery_standard.svg",
                width: AppDimensions.smallIconSize,
                height: AppDimensions.smallIconSize,
              ),
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      service.serviceLabel,
                      style: AppTextStyles.bodySmall,
                      bold: selected,
                    ),
                    PrimaryText(
                      Utils.formatCurrencyWithUnit(service.baseFee),
                      style: AppTextStyles.bodySmall,
                      color: AppColors.neutral5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
