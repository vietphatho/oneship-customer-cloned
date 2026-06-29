import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';

class TrackingSearchInput extends StatefulWidget {
  const TrackingSearchInput({super.key});

  @override
  State<TrackingSearchInput> createState() => _TrackingSearchInputState();
}

class _TrackingSearchInputState extends State<TrackingSearchInput> {
  static const double _trackingInputHeight = 42;
  static const double _scanButtonSize =
      _trackingInputHeight - AppDimensions.xSmallSpacing;
  static const EdgeInsetsDirectional _trackingInputPadding =
      EdgeInsetsDirectional.only(
        start: AppDimensions.smallSpacing,
        end: AppDimensions.xxSmallSpacing,
      );

  final OrderTrackingBloc _orderTrackingBloc = getIt.get();
  final LocationServiceBloc _locationServiceBloc = getIt.get();
  final TextEditingController _trackingNumberCtrl = TextEditingController();

  @override
  void dispose() {
    _trackingNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.smallPaddingHorizontal,
      child: SizedBox(
        height: _trackingInputHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppDimensions.largeBorderRadius,
            border: Border.all(color: AppColors.neutral8),
            boxShadow: [PrimaryBoxShadows.defaultShadow],
          ),
          child: Padding(
            padding: _trackingInputPadding,
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: AppDimensions.smallIconSize,
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                Expanded(
                  child: TextField(
                    controller: _trackingNumberCtrl,
                    textInputAction: TextInputAction.search,
                    textCapitalization: TextCapitalization.characters,
                    style: AppTextStyles.bodyCompact,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "input_tracking_number".tr(),
                      hintStyle: AppTextStyles.bodyXSmall.copyWith(
                        color: AppColors.neutral5,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) => _onSearch(context),
                  ),
                ),
                PrimaryAnimatedPressableWidget(
                  onTap: () => _scanTrackingCode(context),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: AppDimensions.smallSpacing,
                    ),
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.primary,
                      size: AppDimensions.smallIconSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scanTrackingCode(BuildContext context) async {
    final scannedValue = await context.push<String>(
      RouteName.scanTrackingCodePage,
    );

    final trackingNumber = scannedValue?.trim();
    if (!context.mounted || trackingNumber == null || trackingNumber.isEmpty) {
      return;
    }

    _trackingNumberCtrl.text = trackingNumber;
    _trackingNumberCtrl.selection = TextSelection.collapsed(
      offset: trackingNumber.length,
    );
    _onSearch(context);
  }

  void _onSearch(BuildContext context) {
    final trackingNumber = _trackingNumberCtrl.text.trim();

    if (trackingNumber.isEmpty) {
      return;
    }

    _orderTrackingBloc.search(trackingNumber);
    _locationServiceBloc.getCurrentLocation();

    context.push(RouteName.orderTrackingPage);
  }
}
