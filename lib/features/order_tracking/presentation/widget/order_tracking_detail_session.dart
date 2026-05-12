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
        final DeliveryHistoryEntity deliveryHistory =
            _orderTrackingBloc
                .state
                .trackingResult!
                .data!
                .deliveryHistory
                .firstOrNull ??
            DeliveryHistoryEntity();

        return Timeline.tileBuilder(
          padding: EdgeInsets.zero,
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
              final completed = _checkOrderStatus(
                index: index,
                history: deliveryHistory,
              );
              if (!completed) return Container();
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
              final completed = _checkOrderStatus(
                index: index,
                history: deliveryHistory,
              );
              if (!completed) return Container();
              return SolidLineConnector(
                color: completed ? Colors.green : Colors.grey,
                thickness: AppDimensions.xxxSmallSpacing,
              );
            },
            contentsBuilder: (context, index) {
              OrderTrackingStatus stage = OrderTrackingStatus.values[index];

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
                          stage.statusName.tr(),
                          style: AppTextStyles.labelLarge,
                        ),
                        PrimaryText(
                          _getTime(stage: stage, result: deliveryHistory),
                          style: AppTextStyles.titleMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          stage.description,
                          style: AppTextStyles.bodySmall,
                          color: AppColors.neutral6,
                        ),
                        PrimaryText(
                          _getDate(stage: stage, result: deliveryHistory),
                          style: AppTextStyles.bodySmall,
                          color: AppColors.neutral6,
                        ),
                      ],
                    ),
                    AppSpacing.vertical(AppDimensions.mediumSpacing),
                    if (stage == OrderTrackingStatus.pickedUp &&
                        (deliveryHistory.pickupImages?.isNotEmpty ??
                            false)) ...[
                      _ImageSession(imgs: deliveryHistory.pickupImages!),
                    ] else if (stage == OrderTrackingStatus.delivered &&
                        (deliveryHistory.confirmationImages?.isNotEmpty ??
                            false)) ...[
                      _ImageSession(imgs: deliveryHistory.confirmationImages!),
                    ],
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
    switch (stage) {
      case OrderTrackingStatus.delivered:
        return DateTimeUtils.formatTimeFromDT(result.deliveredAt?.toLocal());
      case OrderTrackingStatus.arrivedAtDelivery:
        return DateTimeUtils.formatTimeFromDT(
          result.arrivedAtDelivery?.toLocal(),
        );
      case OrderTrackingStatus.pickedUp:
        return DateTimeUtils.formatTimeFromDT(
          result.pickupConfirmedAt?.toLocal(),
        );
      case OrderTrackingStatus.confirmQty:
        return DateTimeUtils.formatTimeFromDT(
          result.quantityConfirmedAt?.toLocal(),
        );
      case OrderTrackingStatus.arrivedAtShop:
        return DateTimeUtils.formatTimeFromDT(result.scannedAt?.toLocal());
      case OrderTrackingStatus.packed:
        return DateTimeUtils.formatTimeFromDT(
          result.addedToPackageAt?.toLocal(),
        );
    }
  }

  String? _getDate({
    required OrderTrackingStatus stage,
    required DeliveryHistoryEntity result,
  }) {
    switch (stage) {
      case OrderTrackingStatus.delivered:
        return DateTimeUtils.formatDateFromDT(result.deliveredAt?.toLocal());
      case OrderTrackingStatus.arrivedAtDelivery:
        return DateTimeUtils.formatDateFromDT(
          result.arrivedAtDelivery?.toLocal(),
        );
      case OrderTrackingStatus.pickedUp:
        return DateTimeUtils.formatDateFromDT(
          result.pickupConfirmedAt?.toLocal(),
        );
      case OrderTrackingStatus.confirmQty:
        return DateTimeUtils.formatDateFromDT(
          result.quantityConfirmedAt?.toLocal(),
        );
      case OrderTrackingStatus.arrivedAtShop:
        return DateTimeUtils.formatDateFromDT(result.scannedAt?.toLocal());
      case OrderTrackingStatus.packed:
        return DateTimeUtils.formatDateFromDT(
          result.addedToPackageAt?.toLocal(),
        );
    }
  }

  bool _checkOrderStatus({
    required int index,
    required DeliveryHistoryEntity history,
  }) {
    OrderTrackingStatus stage = OrderTrackingStatus.values[index];
    final completed = _getTime(stage: stage, result: history) != null;
    return completed;
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
        padding: EdgeInsets.zero,
        itemBuilder:
            (context, index) => PrimaryImageThumbnail.network(
              StringUtils.getImgUrl(imgs[index]) ?? "",
            ),
      ),
    );
  }
}
