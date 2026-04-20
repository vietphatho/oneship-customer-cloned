import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_image_thumbnail.dart';
import 'package:oneship_customer/core/themes/app_theme.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/string_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:timelines_plus/timelines_plus.dart';

class OrderTrackingDetailSession extends StatelessWidget {
  const OrderTrackingDetailSession({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderTrackingBloc _orderTrackingBloc = getIt.get();
    var colorScheme = AppTheme.getColorScheme(context);

    return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
      bloc: _orderTrackingBloc,
      builder: (context, state) {
        return Timeline.tileBuilder(
          // reverse: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          theme: TimelineThemeData(
            direction: Axis.vertical,
            nodePosition: 0,
            color: AppColors.green,
            indicatorTheme: const IndicatorThemeData(position: 0, size: 24.0),
            connectorTheme: const ConnectorThemeData(thickness: 4.0),
          ),

          // padding: AppDimensions.mediumPaddingAll,
          builder: TimelineTileBuilder.connected(
            itemCount: OrderTrackingStatus.values.length,
            indicatorBuilder: (context, index) {
              final completed = true;
              return DotIndicator(
                color: completed ? Colors.green : Colors.grey,
                size: AppDimensions.xSmallIconSize,
                child: Icon(
                  Icons.check,
                  size: AppDimensions.xxSmallIconSize,
                  color: Colors.white,
                ),
              );
            },
            // indicatorPositionBuilder: (context, index) => 0.5,
            connectorBuilder: (context, index, type) {
              final completed = true;
              return SolidLineConnector(
                color: completed ? Colors.green : Colors.grey,
                thickness: AppDimensions.xxxSmallSpacing,
              );
            },
            contentsBuilder: (context, index) {
              // final stage = stages[index];
              OrderTrackingStatus stage = OrderTrackingStatus.values[index];

              DeliveryHistoryEntity history =
                  state.trackingResult.data?.deliveryHistory.firstOrNull ??
                  DeliveryHistoryEntity();

              return Container(
                decoration: BoxDecoration(
                  // color: AppColors.neutral9,
                  gradient: LinearGradient(
                    colors: [colorScheme.surfaceContainerHigh, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppDimensions.mediumBorderRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.mediumSpacing,
                  vertical: AppDimensions.xSmallSpacing,
                ),
                margin: const EdgeInsets.fromLTRB(
                  AppDimensions.mediumSpacing,
                  0,
                  0,
                  AppDimensions.smallSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          stage.name,
                          style: AppTextStyles.labelLarge,
                        ),
                        PrimaryText(
                          _getTime(stage: stage, result: history),
                          style: AppTextStyles.bodySmall,
                          color: AppColors.neutral6,
                        ),
                      ],
                    ),
                    PrimaryText(
                      stage.description,
                      style: AppTextStyles.bodySmall,
                      color: AppColors.neutral6,
                    ),
                    AppSpacing.vertical(AppDimensions.mediumSpacing),
                    if (stage == OrderTrackingStatus.pickedUp &&
                        (history.pickupImages?.isNotEmpty ?? false)) ...[
                      _ImageSession(imgs: history.pickupImages!),
                    ] else if (stage == OrderTrackingStatus.delivered &&
                        (history.confirmationImages?.isNotEmpty ?? false)) ...[
                      _ImageSession(imgs: history.confirmationImages!),
                    ],
                    // if (stage['desc'] != null) Text(stage['desc'] ?? ''),
                    // if (stage['time'] != null)
                    //   Text(
                    //     stage['time'] ?? '',
                    //     style: const TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  String? _getTime({
    required OrderTrackingStatus stage,
    required DeliveryHistoryEntity result,
  }) {
    // final OrderTrackingBloc _orderTrackingBloc = getIt.get();
    switch (stage) {
      case OrderTrackingStatus.delivered:
        return DateTimeUtils.formatDateFromDT(result.deliveredAt);
      case OrderTrackingStatus.arrivedAtDelivery:
        return DateTimeUtils.formatDateFromDT(result.arrivedAtDelivery);
      case OrderTrackingStatus.pickedUp:
        return DateTimeUtils.formatDateFromDT(result.pickupConfirmedAt);
      case OrderTrackingStatus.confirmQty:
        return DateTimeUtils.formatDateFromDT(result.quantityConfirmedAt);
      case OrderTrackingStatus.arrivedAtShop:
        return DateTimeUtils.formatDateFromDT(result.scannedAt);
      case OrderTrackingStatus.packed:
        return DateTimeUtils.formatDateFromDT(result.addedToPackageAt);
    }
  }
}

class _ImageSession extends StatelessWidget {
  const _ImageSession({super.key, required this.imgs});

  final List<String> imgs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: AppDimensions.smallSpacing,
          crossAxisSpacing: AppDimensions.smallSpacing,
        ),
        itemCount: imgs.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder:
            (context, index) => PrimaryImageThumbnail.network(
              StringUtils.getImgUrl(imgs[index]) ?? "",
            ),
      ),
    );
  }
}
