import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_detail_info_components.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';

class DeliveryServiceDetailPage extends StatelessWidget {
  const DeliveryServiceDetailPage({super.key, required this.service});

  final ShippingServiceConfigEntity service;

  @override
  Widget build(BuildContext context) {
    final detail = service.detailViewModel;

    return OrderDetailInfoScaffold(
      title: service.serviceLabel,
      children: [
        if (detail.type == ShippingServiceDetailType.pricingMatrix)
          _PricingMatrixSection(groups: detail.pricingGroups)
        else if (detail.type == ShippingServiceDetailType.coverageRules)
          _CoverageRulesSection(rules: detail.coverageRules)
        else
          const OrderDetailInfoEmptyCard(
            message: "Chưa có thông tin giá cho dịch vụ này",
          ),
      ],
    );
  }
}

class _PricingMatrixSection extends StatelessWidget {
  const _PricingMatrixSection({required this.groups});

  final List<ShippingServicePricingGroupViewModel> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrderDetailInfoSectionTitle(
          "Bảng giá theo cân nặng và khoảng cách",
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        ...groups.map(
          (group) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.smallSpacing),
            child: _PricingGroupCard(group: group),
          ),
        ),
      ],
    );
  }
}

class _PricingGroupCard extends StatelessWidget {
  const _PricingGroupCard({required this.group});

  final ShippingServicePricingGroupViewModel group;

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            group.weightLabel,
            style: AppTextStyles.labelSmall,
            color: AppColors.neutral2,
            fontWeight: FontWeight.w700,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          const Divider(color: AppColors.neutral8, height: 1),
          AppSpacing.vertical(AppDimensions.xxSmallSpacing),
          ...group.rows.map((row) => _PricingRow(row: row)),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  const _PricingRow({required this.row});

  final ShippingServicePricingRowViewModel row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryText(
              row.distanceLabel,
              style: AppTextStyles.bodyXSmall,
              color: AppColors.neutral4,
            ),
          ),
          PrimaryText(
            Utils.formatCurrencyWithUnit(row.fee),
            style: AppTextStyles.bodySmall,
            color: AppColors.neutral2,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _CoverageRulesSection extends StatelessWidget {
  const _CoverageRulesSection({required this.rules});

  final List<ShippingServiceCoverageRuleViewModel> rules;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrderDetailInfoSectionTitle("Bảng giá đồng giá"),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        ...rules.indexed.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.smallSpacing),
            child: _CoverageRuleCard(rule: entry.$2),
          ),
        ),
      ],
    );
  }
}

class _CoverageRuleCard extends StatelessWidget {
  const _CoverageRuleCard({required this.rule});

  final ShippingServiceCoverageRuleViewModel rule;

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            rule.label,
            style: AppTextStyles.labelSmall,
            color: AppColors.neutral2,
            fontWeight: FontWeight.w700,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          OrderDetailInfoField(
            label: "Khối lượng tối đa",
            value: rule.maxWeightLabel,
          ),
          if (rule.fees.isEmpty)
            const PrimaryText(
              "Phí: --",
              style: AppTextStyles.bodySmall,
              color: AppColors.neutral2,
              fontWeight: FontWeight.w700,
            )
          else if (rule.fees.length == 1)
            _CoverageFeeRow(fee: rule.fees.first)
          else
            ...rule.fees.map((fee) => _CoverageFeeRow(fee: fee)),
        ],
      ),
    );
  }
}

class _CoverageFeeRow extends StatelessWidget {
  const _CoverageFeeRow({required this.fee});

  final ShippingServiceCoverageRuleFeeViewModel fee;

  @override
  Widget build(BuildContext context) {
    final label = fee.label.isEmpty ? "Phí" : "Phí ${fee.label}";

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: PrimaryText(
        "$label: ${Utils.formatCurrencyWithUnit(fee.fee)}",
        style: AppTextStyles.bodySmall,
        color: AppColors.neutral2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
