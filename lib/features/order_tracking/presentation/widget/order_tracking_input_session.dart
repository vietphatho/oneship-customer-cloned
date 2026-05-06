import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';

class OrderTrackingInputSession extends StatefulWidget {
  const OrderTrackingInputSession({super.key});

  @override
  State<OrderTrackingInputSession> createState() =>
      _OrderTrackingInputSessionState();
}

class _OrderTrackingInputSessionState extends State<OrderTrackingInputSession> {
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();

  final TextEditingController _trackingNumberCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumSpacing,
        vertical: AppDimensions.mediumSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: PrimaryTextField(
              label: "input_tracking_number".tr(),
              controller: _trackingNumberCtrl,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                _onSearch();
              },
            ),
          ),
          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
          Expanded(
            child: PrimaryButton.filled(
              label: "search".tr(),
              height: AppDimensions.mediumHeightButton,
              onPressed: _onSearch,
            ),
          ),
        ],
      ),
    );
  }

  void _onSearch() {
    _orderTrackingBloc.search(_trackingNumberCtrl.text.trim());
  }
}
