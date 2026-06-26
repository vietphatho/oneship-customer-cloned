import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_avatar.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_avatar_action_sheet.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_avatar_preview.dart';

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
  const GeneralProfileSummaryCard({super.key});

  static const _emptyText = '--';

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
              _ProfileAvatar(avatarUrl: userProfile.fullAvatarUrl),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      _textOr(userProfile.displayName),
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 19),
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.phone_outlined,
                      text: _textOr(userProfile.userPhone),
                    ),
                    AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.mail_outline_rounded,
                      text: _emailText(userProfile.userEmail),
                    ),
                    AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                    _SmallInfoLine(
                      icon: Icons.location_on_outlined,
                      text: _addressText(
                        authAddress: userProfile.profile?.fullAddress,
                        authWard: userProfile.profile?.wardName,
                        authProvince: userProfile.profile?.provinceName,
                      ),
                    ),
                  ],
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

  String _emailText(String? value) {
    return _textOr(value);
  }

  String _addressText({
    String? authAddress,
    String? authWard,
    String? authProvince,
  }) {
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
  const _ProfileAvatar({required this.avatarUrl});

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
