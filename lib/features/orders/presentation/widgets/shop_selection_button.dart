import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/management/presentation/bloc/management_bloc.dart';
import 'package:oneship_customer/features/management/presentation/bloc/management_state.dart';

class ShopSelectionButton extends StatelessWidget {
  const ShopSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ManagementBloc _managementBloc = getIt.get();

    return BlocBuilder<ManagementBloc, ManagementState>(
      bloc: _managementBloc,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
            vertical: AppDimensions.xxSmallSpacing,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral6),
            borderRadius: AppDimensions.mediumBorderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.house,
                color: AppColors.primary,
                size: AppDimensions.smallIconSize,
              ),
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              PrimaryText(
                _managementBloc.currentShop?.shopName,
                style: AppTextStyles.labelMedium,
              ),
              AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.neutral6,
              ),
            ],
          ),
        );
      },
    );
  }
}
