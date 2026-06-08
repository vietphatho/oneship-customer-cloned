import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

class PrimaryMenuItemData {
  const PrimaryMenuItemData({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.trailingText,
    this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool enabled;
}

class PrimaryMenuItem extends StatelessWidget {
  const PrimaryMenuItem({
    super.key,
    required this.data,
    this.showDivider = true,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimensions.mediumSpacing,
      vertical: AppDimensions.mediumSpacing,
    ),
  });

  final PrimaryMenuItemData data;
  final bool showDivider;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final item = Column(
      children: [
        Padding(
          padding: padding,
          child: Row(
            children: [
              Icon(
                data.icon,
                color: data.enabled ? data.iconColor : AppColors.neutral6,
                size: AppDimensions.mediumIconSize,
              ),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              Expanded(
                child: PrimaryText(
                  data.label,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 16),
                  color: data.enabled ? AppColors.neutral2 : AppColors.neutral6,
                ),
              ),
              if (data.trailingText != null) ...[
                PrimaryText(
                  data.trailingText,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                  color: AppColors.neutral5,
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              ],
              if (data.onTap != null && data.enabled)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.neutral5,
                  size: AppDimensions.mediumIconSize,
                ),
            ],
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 56),
            child: Divider(height: 1, color: AppColors.neutral8),
          ),
      ],
    );

    if (data.onTap == null || !data.enabled) return item;

    return PrimaryAnimatedPressableWidget(onTap: data.onTap, child: item);
  }
}
