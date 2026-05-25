import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';

class CustomerOrderTrackingInputSession extends StatefulWidget {
  const CustomerOrderTrackingInputSession({super.key});

  @override
  State<CustomerOrderTrackingInputSession> createState() =>
      _CustomerOrderTrackingInputSessionState();
}

class _CustomerOrderTrackingInputSessionState
    extends State<CustomerOrderTrackingInputSession> {
  final TextEditingController _trackingNumberCtrl = TextEditingController();
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.mediumSpacing,
        right: AppDimensions.mediumSpacing,
        bottom: AppDimensions.mediumSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: PrimaryTextField(
              controller: _trackingNumberCtrl,
              hintText: "input_tracking_number".tr(),
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              onFieldSubmitted: (value) {
                _onSearch();
              },
            ),
          ),
          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
          Expanded(
            child: SecondaryButton.filled(
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
    if (_trackingNumberCtrl.text.isNotEmpty) {
      _orderTrackingBloc.search(_trackingNumberCtrl.text.trim());
    }
  }
}
