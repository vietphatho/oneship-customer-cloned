import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_selection_button.dart';

class ShopAppBar extends StatelessWidget {
  const ShopAppBar({super.key, this.useDarkContent = false});

  final bool useDarkContent;

  @override
  Widget build(BuildContext context) {
    final authBloc = getIt.get<AuthBloc>();
    final contentColor = useDarkContent ? AppColors.neutral1 : Colors.white;

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      buildWhen: (_, state) => state is AuthFetchedUserProfileState,
      builder: (context, _) {
        final displayName = authBloc.userProfile.displayName?.trim();
        final greetingName = displayName == null || displayName.isEmpty
            ? 'shop_home.default_shop_name'.tr()
            : displayName;

        return SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.mediumSpacing,
              vertical: AppDimensions.xSmallSpacing,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _ShopHomeAvatar(),
                      AppSpacing.horizontal(AppDimensions.smallSpacing),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              'shop_home.greeting'.tr(
                                namedArgs: {'name': greetingName},
                              ),
                              overflow: TextOverflow.ellipsis,
                              color: contentColor,
                              style: AppTextStyles.titleMedium,
                            ),
                            PrimaryText(
                              'shop_home.subtitle'.tr(),
                              overflow: TextOverflow.ellipsis,
                              color: contentColor,
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _NotificationButton(contentColor: contentColor),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                const ShopSelectionButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.contentColor});

  final Color contentColor;

  @override
  Widget build(BuildContext context) {
    return PrimaryIconButton(
      icon: Icon(
        Icons.notifications_none_rounded,
        color: contentColor,
        size: AppDimensions.smallIconSize,
      ),
      size: 36,
      borderColor: Colors.transparent,
      showBadgeDot: true,
      boxShadow: const [],
    );
  }
}

class _ShopHomeAvatar extends StatelessWidget {
  const _ShopHomeAvatar();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        getIt.get<ShopMasterBloc>().changeTab(BottomNavigationItem.menu);
      },
      child: ClipOval(
        child: Image.asset(
          ImagePath.shopHomeAvatarOzoShipGenerated,
          width: AppDimensions.homeAvatarRadius * 2,
          height: AppDimensions.homeAvatarRadius * 2,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
