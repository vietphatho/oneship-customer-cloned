import 'package:oneship_shop/core/base/base_import_components.dart';

class CustomerOrderTrackingInputSession extends StatefulWidget {
  const CustomerOrderTrackingInputSession({super.key});

  @override
  State<CustomerOrderTrackingInputSession> createState() =>
      _CustomerOrderTrackingInputSessionState();
}

class _CustomerOrderTrackingInputSessionState
    extends State<CustomerOrderTrackingInputSession> {
  final TextEditingController _trackingNumberCtrl = TextEditingController();

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
              label: "input_tracking_number".tr(),
              controller: _trackingNumberCtrl,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
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

  void _onSearch() {}
}
