import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_frame.dart';

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
