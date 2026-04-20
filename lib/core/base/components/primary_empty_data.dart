import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';

class PrimaryEmptyData extends StatelessWidget {
  const PrimaryEmptyData({super.key});

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
        ],
      ),
    );
  }
}
