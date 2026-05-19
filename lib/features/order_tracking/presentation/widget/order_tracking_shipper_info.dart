import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/themes/app_theme.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';

class OrderTrackingShipperInfoSession extends StatelessWidget {
  const OrderTrackingShipperInfoSession({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderTrackingBloc _orderTrackingBloc = getIt.get();
    var colorScheme = AppTheme.getColorScheme(context);

    return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
      bloc: _orderTrackingBloc,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: AppDimensions.largeBorderRadius,
          ),
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
            vertical: AppDimensions.smallSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                state.trackingResult!.data?.trackingCode,
                style: AppTextStyles.labelLarge,
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.person_circle_fill,
                    size: AppDimensions.defaultAvatarRadius,
                    color: AppColors.neutral2,
                  ),
                  AppSpacing.horizontal(AppDimensions.smallSpacing),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        state.trackingResult!.data?.shipper?.name,
                        style: AppTextStyles.labelLarge,
                        color: AppColors.primary,
                      ),
                      PrimaryText(
                        state.trackingResult!.data?.shipper?.phone,
                        // style: AppTextStyles.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              Row(
                children: [
                  PrimaryText("${"service_type".tr()}: "),
                  PrimaryText(
                    state.trackingResult!.data?.serviceCode,
                    style: AppTextStyles.labelLarge,
                  ),
                ],
              ),
              Row(
                children: [
                  PrimaryText("${"weight".tr()}: "),
                  PrimaryText(
                    Utils.formatWeightWithUnit(
                      state.trackingResult!.data?.weight,
                    ),
                    style: AppTextStyles.labelLarge,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
