import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_dialog.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/core/navigation/route_name.dart';
import 'package:oneship_shop/core/navigation/route_observer_page.dart';
import 'package:oneship_shop/di/injection_container.dart';
import 'package:oneship_shop/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_shop/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_shop/features/order_tracking/presentation/bloc/order_tracking_state.dart';

class OrderTrackingInputContainer extends StatefulWidget {
  const OrderTrackingInputContainer();

  @override
  State<OrderTrackingInputContainer> createState() =>
      _OrderTrackingInputContainerState();
}

class _OrderTrackingInputContainerState
    extends State<OrderTrackingInputContainer> {
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();

  final TextEditingController _trackingNumberCtrl = TextEditingController();

  @override
  void dispose() {
    _trackingNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Material(
            color: Colors.transparent,
            child: PrimaryTextField(
              controller: _trackingNumberCtrl,
              textInputAction: TextInputAction.done,
              hintText: 'input'.tr(),
              textCapitalization: TextCapitalization.characters,
              onFieldSubmitted: (value) {
                _onSearch();
              },
            ),
          ),
        ),
        AppSpacing.horizontal(AppDimensions.smallSpacing),
        Expanded(
          child: BlocListener<OrderTrackingBloc, OrderTrackingState>(
            bloc: _orderTrackingBloc,
            listener: _handleOrderTrackingListener,
            child: PrimaryButton.filled(
              label: 'search'.tr(),
              onPressed: _onSearch,
            ),
          ),
        ),
      ],
    );
  }

  void _onSearch() {
    if (_trackingNumberCtrl.text.isNotEmpty) {
      _orderTrackingBloc.search(_trackingNumberCtrl.text.trim());
    }
  }

  void _handleOrderTrackingListener(
    BuildContext context,
    OrderTrackingState state,
  ) {
    var currentRoute = RouteObserverPage.currentRoute;
    if (currentRoute == RouteName.homePage) {
      switch (state.trackingResult!.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          if (!(state.trackingResult?.data?.isEmpty ?? true)) {
            context.push(RouteName.orderTrackingPage);
          }
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(context);
          break;
      }
    }
  }
}
