import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_delivery_service_card.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class CreateOrderDeliveryServiceSelector extends StatefulWidget {
  const CreateOrderDeliveryServiceSelector({
    super.key,
    this.firstServiceOnly = false,
    this.lockSelection = false,
  });

  final bool firstServiceOnly;
  final bool lockSelection;

  @override
  State<CreateOrderDeliveryServiceSelector> createState() =>
      _CreateOrderDeliveryServiceSelectorState();
}

class _CreateOrderDeliveryServiceSelectorState
    extends State<CreateOrderDeliveryServiceSelector> {
  final CreateOrderBloc _createOrderBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  bool _didRequestDefaultSelection = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _selectDefaultServiceIfNeeded(_shopBloc.state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc, ShopState>(
      bloc: _shopBloc,
      listenWhen: (previous, current) =>
          previous.shippingServiceTypesResource.state != Result.success &&
          current.shippingServiceTypesResource.state == Result.success,
      listener: (context, state) => _selectDefaultServiceIfNeeded(state),
      child: BlocBuilder<CreateOrderBloc, CreateOrderState>(
        bloc: _createOrderBloc,
        builder: (context, state) {
          final services = widget.firstServiceOnly
              ? _shopBloc.state.shippingServices.take(1).toList()
              : _shopBloc.state.shippingServices;

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
                itemCount: services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.firstServiceOnly ? 1 : 2,
                  crossAxisSpacing: AppDimensions.xSmallSpacing,
                  mainAxisSpacing: AppDimensions.xSmallSpacing,
                  mainAxisExtent: 56,
                ),
                itemBuilder: (context, index) {
                  final service = services[index];

                  return CreateOrderDeliveryServiceCard(
                    service: service,
                    selected:
                        state.draftRequest.serviceConfig?.serviceCode ==
                        service.serviceCode,
                    onTap: widget.lockSelection
                        ? () {}
                        : () => _createOrderBloc.changeOrderInfo(
                            serviceConfig: service,
                          ),
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
      ),
    );
  }

  void _selectDefaultServiceIfNeeded(ShopState state) {
    if (_didRequestDefaultSelection) return;
    if (state.shippingServiceTypesResource.state != Result.success) return;
    if (state.shippingServices.isEmpty) return;

    _didRequestDefaultSelection = true;
    _createOrderBloc.selectDefaultShippingServiceIfNeeded(
      state.shippingServices,
      force: widget.firstServiceOnly,
    );
  }
}
