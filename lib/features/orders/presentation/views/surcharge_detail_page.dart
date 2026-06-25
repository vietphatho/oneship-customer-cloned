import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_detail_info_components.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/surcharge_entity.dart';

class SurchargeDetailPage extends StatelessWidget {
  const SurchargeDetailPage({super.key, required this.surcharge});

  final SurchargeEntity surcharge;

  @override
  Widget build(BuildContext context) {
    final detail = surcharge.detailViewModel;

    return OrderDetailInfoScaffold(
      title: surcharge.label,
      children: [
        if (detail.tiers.isEmpty)
          const OrderDetailInfoEmptyCard(
            message: "Chưa có thông tin bảng giá cho dịch vụ này",
          )
        else
          _SurchargeTierSection(tiers: detail.tiers),
      ],
    );
  }
}

class _SurchargeTierSection extends StatelessWidget {
  const _SurchargeTierSection({required this.tiers});

  final List<SurchargeTierViewModel> tiers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrderDetailInfoSectionTitle("Bảng giá theo từng mức"),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        ...tiers.map(
          (tier) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.smallSpacing),
            child: _SurchargeTierCard(tier: tier),
          ),
        ),
      ],
    );
  }
}

class _SurchargeTierCard extends StatelessWidget {
  const _SurchargeTierCard({required this.tier});

  final SurchargeTierViewModel tier;

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              tier.tierLabel,
              style: AppTextStyles.labelSmall,
              color: AppColors.neutral2,
            ),
            AppSpacing.vertical(AppDimensions.xxSmallSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryText(
                  tier.rangeLabel,
                  style: AppTextStyles.bodyXSmall,
                  color: AppColors.neutral4,
                ),
                PrimaryText(
                  tier.feeLabel,
                  style: AppTextStyles.bodySmall,
                  color: AppColors.neutral2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
