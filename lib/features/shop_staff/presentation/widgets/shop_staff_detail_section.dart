import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';

class ShopStaffDetailSection extends StatelessWidget {
  const ShopStaffDetailSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return PrimaryFrame(
      padding: AppDimensions.smallPaddingAll,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.secondary,
                size: AppDimensions.xSmallIconSize,
              ),
              AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
              Expanded(
                child: PrimaryText(
                  title,
                  style: AppTextStyles.titleMedium,
                  color: AppColors.secondary,
                  bold: true,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          ...children,
        ],
      ),
    );
  }
}

class ShopStaffInfoRow extends StatelessWidget {
  const ShopStaffInfoRow({
    super.key,
    required this.label,
    this.value = "",
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.xSmallSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: PrimaryText(
              label,
              style: AppTextStyles.bodyMedium,
              color: AppColors.neutral4,
            ),
          ),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.centerRight,
              child:
                  trailing ??
                  PrimaryText(
                    value,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.titleSmall,
                    color: AppColors.neutral1,
                    maxLine: 2,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
