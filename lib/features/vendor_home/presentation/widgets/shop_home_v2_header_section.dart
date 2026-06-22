part of '../views/vendor_home_page.dart';

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({this.vendor});

  static const _emptyText = '--';

  final ShopVendorEntity? vendor;

  @override
  Widget build(BuildContext context) {
    final userProfile = getIt.get<AuthBloc>().userProfile;

    return SizedBox(
      height: 136,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -16,
            right: -16,
            top: -14,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.shopHomeV2HeaderBackground,
                    AppColors.shopHomeV2Background,
                    AppColors.shopHomeV2HeaderBackground,
                  ],
                  stops: [0, 0.58, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            right: -28,
            top: 14,
            child: Image.asset(
              ImagePath.shopHomeV2Market,
              width: 276,
              height: 108,
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [PrimaryBoxShadows.defaultShadow],
                ),
                child: _HeaderAvatarImage(
                  avatarUrl: userProfile.avatarUrl,
                ),
              ),
              AppSpacing.horizontal(12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, right: 128),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        'Xin chào, ${_vendorName(userProfile.displayName)}! 👋',
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 17,
                          height: 1.05,
                        ),
                      ),
                      AppSpacing.vertical(9),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.shopHomeV2SoftOrangeBackground,
                          borderRadius: AppDimensions.mediumBorderRadius,
                        ),
                        child: PrimaryText(
                          'Tiểu thương',
                          style: AppTextStyles.labelXSmall.copyWith(
                            color: AppColors.shopHomeV2MerchantBrown,
                            fontSize: 12,
                            height: 1,
                          ),
                        ),
                      ),
                      AppSpacing.vertical(9),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          AppSpacing.horizontal(4),
                          Expanded(
                            child: PrimaryText(
                              _vendorAddress(
                                authAddress: userProfile.profile?.fullAddress,
                                authWard: userProfile.profile?.wardName,
                                authProvince: userProfile.profile?.provinceName,
                              ),
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyXSmall.copyWith(
                                color: AppColors.neutral4,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.neutral4,
                            size: 18,
                          ),
                        ],
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
  }

  String _vendorName(String? authDisplayName) {
    final name = vendor?.vendorName.trim();
    if (name == null || name.isEmpty) return _textOr(authDisplayName);
    return name;
  }

  String _vendorAddress({
    String? authAddress,
    String? authWard,
    String? authProvince,
  }) {
    final address = vendor?.fullAddress.trim();
    if (address != null && address.isNotEmpty) return address;

    final authFullAddress = authAddress?.trim();
    if (authFullAddress != null && authFullAddress.isNotEmpty) {
      return authFullAddress;
    }

    final joinedAddress = [authWard, authProvince]
        .map((item) => item?.trim() ?? '')
        .where((item) => item.isNotEmpty)
        .join(', ');
    return joinedAddress.isEmpty ? _emptyText : joinedAddress;
  }

  String _textOr(String? value) {
    final text = value?.trim();
    if (text != null && text.isNotEmpty) return text;
    return _emptyText;
  }
}

class _HeaderAvatarImage extends StatelessWidget {
  const _HeaderAvatarImage({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl?.trim();

    return ClipOval(
      child: url?.isNotEmpty == true
          ? Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallbackAvatar,
            )
          : _fallbackAvatar,
    );
  }

  Widget get _fallbackAvatar {
    return Image.asset(
      ImagePath.shopHomeAvatarOzoShipGenerated,
      fit: BoxFit.cover,
    );
  }
}
