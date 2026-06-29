import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_avatar.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_avatar_action_sheet.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_avatar_preview.dart';
import 'package:oneship_customer/features/vendor/profile/domain/entities/vendor_profile_entity.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_state.dart';

class VendorProfileTopBar extends StatelessWidget {
  const VendorProfileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PrimaryText(
          'vendor_profile.title'.tr(),
          style: AppTextStyles.titleLarge,
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

class VendorProfileSummaryCard extends StatelessWidget {
  const VendorProfileSummaryCard({super.key});

  static const _emptyText = '--';

  @override
  Widget build(BuildContext context) {
    final authBloc = getIt.get<AuthBloc>();
    final vendorProfileBloc = getIt.get<VendorProfileBloc>();

    return BlocBuilder<VendorProfileBloc, VendorProfileState>(
      bloc: vendorProfileBloc,
      buildWhen: (previous, current) =>
          previous.profileResource != current.profileResource,
      builder: (context, state) {
        final profile = state.profile;
        final userProfile = authBloc.userProfile;

        return PrimaryPanel(
          width: double.infinity,
          padding: AppDimensions.mediumPaddingAll,
          onTap: () => context.push(RouteName.vendorProfileDetailPage),
          child: Row(
            children: [
              _VendorProfileAvatar(avatarUrl: userProfile.fullAvatarUrl),
              AppSpacing.horizontal(AppDimensions.smallSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      _textOr(profile?.vendorName, userProfile.displayName),
                      style: AppTextStyles.titleLarge,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.phone_outlined,
                      text: _textOr(profile?.phone, userProfile.userPhone),
                    ),
                    AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.mail_outline_rounded,
                      text: _textOr(profile?.email, userProfile.userEmail),
                    ),
                    AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.location_on_outlined,
                      text: _textOr(
                        profile?.fullAddress,
                        userProfile.profile?.fullAddress,
                      ),
                    ),
                  ],
                ),
              ),
              // const Icon(
              //   Icons.chevron_right_rounded,
              //   color: AppColors.neutral5,
              //   size: AppDimensions.largeIconSize,
              // ),
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
}

class VendorProfileInfoCard extends StatelessWidget {
  const VendorProfileInfoCard({super.key});

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
        final items = _items(profile);

        return PrimaryPanel(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.smallSpacing,
            AppDimensions.smallSpacing,
            AppDimensions.smallSpacing,
            AppDimensions.largeSpacing,
          ),
          onTap: () => context.push(RouteName.vendorProfileDetailPage),
          child: Column(
            children: [
              Row(
                children: [
                  PrimaryText(
                    'vendor_profile.vendor_info'.tr(),
                    style: AppTextStyles.labelMedium,
                  ),
                  const Spacer(),
                  PrimaryText(
                    'vendor_profile.view_detail'.tr(),
                    style: AppTextStyles.labelXSmall,
                    color: AppColors.primary,
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: AppDimensions.smallIconSize,
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.largeSpacing),
              Row(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    Expanded(child: PrimaryInfoItem(data: items[i])),
                    if (i != items.length - 1) const _InfoDivider(),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<PrimaryInfoItemData> _items(VendorProfileEntity? profile) {
    return [
      PrimaryInfoItemData(
        icon: Icons.storefront_outlined,
        iconColor: AppColors.primary,
        label: 'vendor_profile.vendor_name'.tr(),
        value: _textOr(profile?.vendorName),
      ),
      PrimaryInfoItemData(
        icon: Icons.verified_user_outlined,
        iconColor: AppColors.green,
        label: 'vendor_profile.vendor_code'.tr(),
        value: _textOr(profile?.vendorCode),
      ),
      PrimaryInfoItemData(
        icon: Icons.calendar_month_outlined,
        iconColor: AppColors.info,
        label: 'vendor_profile.created_date'.tr(),
        value: _formatDate(profile?.createdAt),
      ),
      PrimaryInfoItemData(
        icon: Icons.workspace_premium_outlined,
        iconColor: AppColors.investmentPurple,
        label: 'vendor_profile.status'.tr(),
        value: _textOr(profile?.status),
      ),
    ];
  }

  String _textOr(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? _emptyText : text;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return _emptyText;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _VendorProfileAvatar extends StatelessWidget {
  const _VendorProfileAvatar({required this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: () async {
        final action = await showProfileAvatarActionSheet(context);
        if (!context.mounted || action == null) return;

        switch (action) {
          case ProfileAvatarAction.view:
            showProfileAvatarPreview(context, avatarUrl: avatarUrl);
            break;
          case ProfileAvatarAction.change:
            getIt.get<AuthBloc>().updateUserAvatar();
            break;
        }
      },
      child: Hero(
        tag: Constants.profileAvatarHeroKey,
        child: PrimaryAvatar(
          url: avatarUrl,
          radius: AppDimensions.defaultAvatarRadius,
          showStatusIndicator: false,
        ),
      ),
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
            style: AppTextStyles.bodySmall,
            color: AppColors.neutral4,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.mediumBorderStroke,
      height: AppDimensions.displayIconSize,
      color: AppColors.neutral8,
    );
  }
}
