import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/utils/string_utils.dart';
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
        final _shopLogoUrl = _managementBloc.currentShop?.shopLogo;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.xSmallSpacing,
            vertical: AppDimensions.xxSmallSpacing,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral6),
            borderRadius: AppDimensions.mediumBorderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(
              //   CupertinoIcons.house,
              //   color: AppColors.primary,
              //   size: AppDimensions.xSmallIconSize,
              // ),
              if (_shopLogoUrl != null)
                _ShopAvatar(url: StringUtils.getImgUrl(_shopLogoUrl)!),
              AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
              Expanded(
                child: PrimaryText(
                  _managementBloc.currentShop?.shopName,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelMedium,
                ),
              ),
              AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.neutral6,
                size: AppDimensions.xSmallIconSize,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShopAvatar extends StatelessWidget {
  const _ShopAvatar({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.smallIconSize,
      height: AppDimensions.smallIconSize,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover,
        ),
        borderRadius: AppDimensions.xSmallBorderRadius,
      ),
    );
  }
}
