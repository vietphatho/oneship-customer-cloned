import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_image_thumbnail.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/string_utils.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_transport_history_timeline_entity.dart';

class OrderTransportHistoryTimeline extends StatelessWidget {
  const OrderTransportHistoryTimeline({super.key, required this.items});

  final List<OrderTransportHistoryTimelineEntity> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.smallSpacing),
      child: Column(
        children: List.generate(
          items.length,
          (index) => _TimelineItemView(
            item: items[index],
            isFirst: index == 0,
            isLast: index == items.length - 1,
          ),
        ),
      ),
    );
  }
}

class _TimelineItemView extends StatelessWidget {
  const _TimelineItemView({
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  final OrderTransportHistoryTimelineEntity item;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final time = item.time.toLocal();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: AppDimensions.smallSpacing,
                height: AppDimensions.smallSpacing,
                decoration: BoxDecoration(
                  color: isFirst ? AppColors.primary : AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(
                      vertical: AppDimensions.xxSmallSpacing,
                    ),
                    color: AppColors.neutral5,
                  ),
                ),
            ],
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.largeSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              item.title.tr(),
                              style: AppTextStyles.labelMedium,
                            ),
                            PrimaryText(
                              item.description.tr(),
                              style: AppTextStyles.bodySmall,
                            ),
                            if (item.showCompletedTag) ...[
                              AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                              const _CompletedTag(),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PrimaryText(
                            DateTimeUtils.formatTimeFromDT(time) ?? '',
                            style: AppTextStyles.bodyXSmall,
                            color: AppColors.neutral6,
                          ),
                          PrimaryText(
                            DateTimeUtils.formatDateFromDT(time) ?? '',
                            style: AppTextStyles.bodyXSmall,
                            color: AppColors.neutral6,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (item.images.isNotEmpty) ...[
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                    SizedBox(
                      height: 56,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: item.images.length,
                        separatorBuilder: (_, __) =>
                            AppSpacing.horizontal(AppDimensions.smallSpacing),
                        itemBuilder: (context, index) {
                          final imageUrl =
                              StringUtils.getImgUrl(item.images[index]) ?? '';
                          return SizedBox(
                            width: 56,
                            child: PrimaryImageThumbnail.network(
                              imageUrl,
                              canPreview: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedTag extends StatelessWidget {
  const _CompletedTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.12),
        border: Border.all(color: AppColors.green),
        borderRadius: AppDimensions.smallBorderRadius,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xSmallSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: PrimaryText(
        'completed'.tr(),
        style: AppTextStyles.labelXSmall,
        color: AppColors.green,
      ),
    );
  }
}
