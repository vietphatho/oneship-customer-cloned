import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/utils/string_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopSelectionButton extends StatelessWidget {
  const ShopSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopBloc _shopBloc = getIt.get();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: _shopBloc,
      builder: (context, state) {
        final _shopLogoUrl = state.currentShop?.shopLogo;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.primary,
              width: AppDimensions.smallBorderStroke,
            ),
            borderRadius: AppDimensions.largeBorderRadius,
          ),
          child: DropdownButton(
            items:
                state.shopsResource.data?.data
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: PrimaryText(
                          e.shopName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
            value: state.currentShop,
            underline: SizedBox(),
            onChanged: (_) {},
          ),
        );

        return DropdownMenu(
          trailingIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.neutral6,
          ),
          selectedTrailingIcon: const Icon(
            Icons.keyboard_arrow_up,
            color: AppColors.neutral6,
          ),
          enableSearch: false,
          initialSelection: state.currentShop,
          dropdownMenuEntries:
              state.shopsResource.data?.data
                  .map((e) => DropdownMenuEntry(label: e.shopName, value: e))
                  .toList() ??
              [],
          menuStyle: MenuStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.only(top: 8)),
            elevation: WidgetStateProperty.all(4),
            // backgroundColor: WidgetStateProperty.all(
            //   colorScheme.surfaceContainerHigh,
            // ),
            visualDensity: VisualDensity.compact,
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          textStyle: AppTextStyles.labelSmall.copyWith(
            overflow: TextOverflow.ellipsis,
          ),
          expandedInsets: EdgeInsets.zero,
          // onChanged: (value) {},
        );

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
                  state.currentShop?.shopName,
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
