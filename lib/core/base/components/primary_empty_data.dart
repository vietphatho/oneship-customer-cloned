import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

class PrimaryEmptyData extends StatelessWidget {
  const PrimaryEmptyData({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.folder,
            size: AppDimensions.displayIconSize,
            color: AppColors.neutral6,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          PrimaryText(
            "empty_data".tr(),
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral6,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),

          if (onRetry != null)
            PrimaryAnimatedPressableWidget(
              onTap: onRetry,
              child: Padding(
                padding: AppDimensions.smallPaddingAll,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, color: AppColors.primary),
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    PrimaryText(
                      'retry'.tr(),
                      color: AppColors.primary,
                      style: AppTextStyles.labelLarge,
                      decoration: TextDecoration.underline,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
