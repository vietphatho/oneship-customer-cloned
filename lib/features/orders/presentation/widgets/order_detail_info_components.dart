import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';

class OrderDetailInfoScaffold extends StatelessWidget {
  const OrderDetailInfoScaffold({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: title),
      backgroundColor: AppColors.neutral9,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
          children: children,
        ),
      ),
    );
  }
}

class OrderDetailInfoSectionTitle extends StatelessWidget {
  const OrderDetailInfoSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return PrimaryText(
      title,
      style: AppTextStyles.labelSmall,
      color: AppColors.neutral2,
      fontWeight: FontWeight.w700,
    );
  }
}

class OrderDetailInfoEmptyCard extends StatelessWidget {
  const OrderDetailInfoEmptyCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: AppDimensions.largeIconSize,
            color: AppColors.neutral6,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          PrimaryText(
            message,
            style: AppTextStyles.bodySmall,
            color: AppColors.neutral4,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OrderDetailInfoField extends StatelessWidget {
  const OrderDetailInfoField({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PrimaryText(
              label,
              style: AppTextStyles.bodyXSmall,
              color: AppColors.neutral5,
            ),
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: PrimaryText(
                value,
                style: AppTextStyles.bodyXSmall,
                color: AppColors.neutral2,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
