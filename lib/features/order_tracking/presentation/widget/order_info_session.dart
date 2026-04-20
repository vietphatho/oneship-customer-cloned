import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/themes/app_theme.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';

class OrderInfoSession extends StatelessWidget {
  const OrderInfoSession({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderTrackingBloc _orderTrackingBloc = getIt.get();
    var colorScheme = AppTheme.getColorScheme(context);

    return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
      bloc: _orderTrackingBloc,
      builder: (context, state) {
        return Row(
          children: [
            PrimaryText("${"order_code".tr()}: "),
            PrimaryText(
              state.trackingResult.data?.trackingCode,
              style: AppTextStyles.labelLarge,
            ),
          ],
        );
      },
    );
  }
}
