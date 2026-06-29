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
                  // GestureDetector(
                  //   onTap: () =>
                  //       context.push(RouteName.vendorProfileDetailPage),
                  //   child: const PrimaryAvatar(showStatusIndicator: false),
                  // ),
                  const _VendorAvatar(),
                  AppSpacing.horizontal(12),
                  Expanded(
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
                            horizontal: AppDimensions.xSmallSpacing,
                            vertical: AppDimensions.xxxSmallSpacing,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.shopHomeV2SoftOrangeBackground,
                            borderRadius: AppDimensions.mediumBorderRadius,
                          ),
                          child: PrimaryText(
                            'vendor_profile.merchant'.tr(),
                            style: AppTextStyles.labelXSmall,
                            color: AppColors.shopHomeV2MerchantBrown,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.xSmallSpacing),
                        Padding(
                          padding: const EdgeInsets.only(right: 114),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  maxLine: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyXXSmall,
                                  color: AppColors.neutral4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   right: -2,
              //   top: 14,
              //   child: PrimaryIconButton(
              //     icon: const Icon(Icons.notifications_none_rounded),
              //     size: 44,
              //     iconColor: AppColors.neutral1,
              //     backgroundColor: Colors.white,
              //     borderColor: Colors.transparent,
              //     borderRadius: AppDimensions.largeBorderRadius,
              //     showBadgeDot: true,
              //     boxShadow: [PrimaryBoxShadows.defaultShadow],
              //   ),
              // ),
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

class _VendorAvatar extends StatelessWidget {
  const _VendorAvatar();

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = getIt.get();
    String? userAvatar = _authBloc.userProfile.fullAvatarUrl;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        getIt.get<ShopMasterBloc>().changeTab(BottomNavigationItem.menu);
      },
      child: PrimaryAvatar(showStatusIndicator: false, url: userAvatar),
    );
  }
}
