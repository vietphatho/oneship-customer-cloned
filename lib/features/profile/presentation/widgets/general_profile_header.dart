import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';

class GeneralProfileTopBar extends StatelessWidget {
  const GeneralProfileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PrimaryText(
          'Hồ sơ',
          style: AppTextStyles.titleLarge.copyWith(fontSize: 24),
        ),
        const Spacer(),
        const PrimaryIconButton(
          icon: Icon(Icons.notifications_none_rounded),
          badgeText: '3',
        ),
        AppSpacing.horizontal(AppDimensions.xSmallSpacing),
        const PrimaryIconButton(icon: Icon(Icons.settings_outlined)),
      ],
    );
  }
}

class GeneralProfileSummaryCard extends StatelessWidget {
  const GeneralProfileSummaryCard({super.key, this.vendor});

  static const _emptyText = '--';

  final ShopVendorEntity? vendor;

  @override
  Widget build(BuildContext context) {
    final authBloc = getIt.get<AuthBloc>();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        final userProfile = authBloc.userProfile;

        return PrimaryPanel(
          width: double.infinity,
          padding: AppDimensions.mediumPaddingAll,
          onTap: () => context.push(RouteName.profileDetailPage),
          child: Row(
            children: [
              const _ProfileAvatar(),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      _textOr(vendor?.vendorName, userProfile.displayName),
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 19),
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.phone_outlined,
                      text: _textOr(vendor?.phone, userProfile.userPhone),
                    ),
                    AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.mail_outline_rounded,
                      text: _emailText(vendor?.email, userProfile.userEmail),
                    ),
                    AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.location_on_outlined,
                      text: _addressText(
                        vendorAddress: vendor?.fullAddress,
                        authAddress: userProfile.profile?.fullAddress,
                        authWard: userProfile.profile?.wardName,
                        authProvince: userProfile.profile?.provinceName,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.neutral5,
                size: AppDimensions.largeIconSize,
              ),
            ],
          ),
        );
      },
    );
  }

  String _textOr(String? value, String? fallback) {
    final text = value?.trim();
    if (text != null && text.isNotEmpty) return text;

    final fallbackText = fallback?.trim();
    if (fallbackText != null && fallbackText.isNotEmpty) return fallbackText;

    return _emptyText;
  }

  String _emailText(String? value, String? fallback) {
    return _textOr(value, fallback);
  }

  String _addressText({
    String? vendorAddress,
    String? authAddress,
    String? authWard,
    String? authProvince,
  }) {
    final vendorFullAddress = vendorAddress?.trim();
    if (vendorFullAddress != null && vendorFullAddress.isNotEmpty) {
      return vendorFullAddress;
    }

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
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return const PrimaryAssetAvatar(
      image: ImagePath.shopHomeAvatarOzoShipGenerated,
      backgroundImage: ImagePath.shopHomeAvatarBackground,
      imageSize: 68,
      overlayImage: ImagePath.profileEditBadge,
      radius: 46,
    );
  }
}

class _SmallInfoLine extends StatelessWidget {
  const _SmallInfoLine({required this.icon, required this.text});

  final IconData icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimensions.xSmallIconSize,
          color: AppColors.neutral5,
        ),
        AppSpacing.horizontal(AppDimensions.xSmallSpacing),
        Expanded(
          child: PrimaryText(
            text,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
            color: AppColors.neutral4,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
