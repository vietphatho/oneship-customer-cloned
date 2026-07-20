import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_avatar.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_selection_button.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';

class ShopAppBar extends StatelessWidget {
  const ShopAppBar({super.key, this.useDarkContent = false});

  final bool useDarkContent;

  @override
  Widget build(BuildContext context) {
    final authBloc = getIt.get<AuthBloc>();
    final contentColor = useDarkContent ? AppColors.neutral1 : Colors.white;
    final ShopBloc _shopBloc = getIt.get();

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
                      AppSpacing.horizontal(AppDimensions.xSmallSpacing),
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
                            BlocSelector<ShopBloc, ShopState, BriefShopEntity?>(
                              bloc: _shopBloc,
                              selector: (state) => state.currentShop,
                              builder: (context, currentShop) {
                                return PrimaryText(
                                  "${'shop'.tr()}: ${currentShop?.shopName}",
                                  overflow: TextOverflow.ellipsis,
                                  color: contentColor,
                                  style: AppTextStyles.bodyXSmall,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // _NotificationButton(contentColor: contentColor),
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
