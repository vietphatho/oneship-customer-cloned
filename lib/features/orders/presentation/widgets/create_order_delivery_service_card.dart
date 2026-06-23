import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';

class CreateOrderDeliveryServiceCard extends StatelessWidget {
  const CreateOrderDeliveryServiceCard({
    super.key,
    required this.service,
    required this.selected,
    required this.onTap,
    required this.onInfoTap,
  });

  final ShippingServiceConfigEntity service;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppDimensions.largeBorderRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.neutral8,
          ),
          borderRadius: AppDimensions.largeBorderRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: PrimaryText(
                service.serviceLabel,
                style: AppTextStyles.bodySmall,
                bold: selected,
                maxLine: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (service.hasInfo) ...[
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              InkWell(
                borderRadius: AppDimensions.smallBorderRadius,
                onTap: onInfoTap,
                child: const Padding(
                  padding: EdgeInsets.all(AppDimensions.xxSmallSpacing),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: AppDimensions.xSmallIconSize,
                    color: AppColors.neutral6,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
