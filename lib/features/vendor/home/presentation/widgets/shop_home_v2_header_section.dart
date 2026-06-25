part of '../views/vendor_home_page.dart';

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  static const _emptyText = '--';

  @override
  Widget build(BuildContext context) {
    final vendorProfileBloc = getIt.get<VendorProfileBloc>();

    return BlocBuilder<VendorProfileBloc, VendorProfileState>(
      bloc: vendorProfileBloc,
      buildWhen: (previous, current) =>
          previous.profileResource != current.profileResource,
      builder: (context, state) {
        final profile = state.profile;

        return SizedBox(
          height: 136,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -16,
                right: -16,
                top: -14,
                bottom: -6,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.shopHomeV2HeaderBackground.withAlpha(175),
                        AppColors.shopHomeV2Background,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -18,
                top: 48,
                child: Image.asset(
                  ImagePath.shopHomeV2MarketCutout,
                  width: 210,
                  height: 82,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.push(RouteName.vendorProfileDetailPage),
                    child: Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [PrimaryBoxShadows.defaultShadow],
                      ),
                      child: const _HeaderAvatarImage(),
                    ),
                  ),
                  AppSpacing.horizontal(12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryText(
                            'vendor_home.greeting'.tr(
                              namedArgs: {'name': _textOr(profile?.vendorName)},
                            ),
                            maxLine: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMedium,
                          ),
                          AppSpacing.vertical(AppDimensions.xSmallSpacing),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.smallSpacing,
                              vertical: AppDimensions.xxSmallSpacing,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.shopHomeV2SoftOrangeBackground,
                              borderRadius: AppDimensions.mediumBorderRadius,
                            ),
                            child: PrimaryText(
                              'vendor_profile.merchant'.tr(),
                              style: AppTextStyles.labelXSmall.copyWith(
                                color: AppColors.shopHomeV2MerchantBrown,
                              ),
                            ),
                          ),
                          AppSpacing.vertical(AppDimensions.xSmallSpacing),
                          Padding(
                            padding: const EdgeInsets.only(right: 126),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.primary,
                                  size: AppDimensions.smallIconSize,
                                ),
                                AppSpacing.horizontal(
                                  AppDimensions.xxxSmallSpacing,
                                ),
                                Expanded(
                                  child: PrimaryText(
                                    _textOr(profile?.fullAddress),
                                    maxLine: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodyXSmall.copyWith(
                                      color: AppColors.neutral4,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.neutral4,
                                  size: AppDimensions.smallIconSize,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: -2,
                top: 14,
                child: PrimaryIconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  size: 44,
                  iconColor: AppColors.neutral1,
                  backgroundColor: Colors.white,
                  borderColor: Colors.transparent,
                  borderRadius: AppDimensions.largeBorderRadius,
                  showBadgeDot: true,
                  boxShadow: [PrimaryBoxShadows.defaultShadow],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _textOr(String? value) {
    final text = value?.trim();
    if (text != null && text.isNotEmpty) return text;
    return _emptyText;
  }
}

class _HeaderAvatarImage extends StatelessWidget {
  const _HeaderAvatarImage();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        ImagePath.shopHomeAvatarOzoShipGenerated,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
