import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_delivery_service_card.dart';
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _shopBloc.state.shippingServices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppDimensions.xSmallSpacing,
                mainAxisSpacing: AppDimensions.xSmallSpacing,
                mainAxisExtent: 56,
              ),
              itemBuilder: (context, index) {
                final service = _shopBloc.state.shippingServices[index];

                return CreateOrderDeliveryServiceCard(
                  service: service,
                  selected: state.draftRequest.serviceConfig == service,
                  onTap: () =>
                      _createOrderBloc.changeOrderInfo(serviceConfig: service),
                  onInfoTap: () => context.push(
                    RouteName.deliveryServiceDetailPage,
                    extra: service,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
