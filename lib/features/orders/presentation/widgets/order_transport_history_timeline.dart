import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xxLargeSpacing,
        vertical: AppDimensions.largeSpacing,
      ),
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
          SizedBox(
            width: AppDimensions.largeSpacing,
            child: Column(
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
                              item.title,
                              style: AppTextStyles.labelLarge,
                            ),
                            PrimaryText(
                              item.description,
                              style: AppTextStyles.bodyMedium,
                            ),
                            if (item.showCompletedTag) ...[
                              AppSpacing.vertical(
                                AppDimensions.xxSmallSpacing,
                              ),
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
                            style: AppTextStyles.bodyMedium,
                          ),
                          PrimaryText(
                            DateTimeUtils.formatDateFromDT(time) ?? '',
                            style: AppTextStyles.bodyMedium,
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
                        separatorBuilder:
                            (_, __) =>
                                AppSpacing.horizontal(AppDimensions.smallSpacing),
                        itemBuilder: (context, index) {
                          final imageUrl =
                              StringUtils.getImgUrl(item.images[index]) ?? '';
                          return GestureDetector(
                            onTap: () => _showImagePreview(context, imageUrl),
                            child: SizedBox(
                              width: 56,
                              child: PrimaryImageThumbnail.network(imageUrl),
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

  void _showImagePreview(BuildContext context, String imageUrl) {
    if (imageUrl.isEmpty) return;

    PrimaryDialog.showDefaultDialog(
      context,
      child: GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Material(
          color: Colors.black.withOpacity(0.85),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4,
                    child: Image.network(imageUrl, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: AppDimensions.mediumSpacing,
                  right: AppDimensions.mediumSpacing,
                  child: IconButton(
                    onPressed:
                        () => Navigator.of(context, rootNavigator: true).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
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
        'Đã hoàn thành',
        style: AppTextStyles.labelXSmall,
        color: AppColors.green,
      ),
    );
  }
}
