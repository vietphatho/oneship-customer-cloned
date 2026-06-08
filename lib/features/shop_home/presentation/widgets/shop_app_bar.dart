import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
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
    final contentColor = useDarkContent ? Colors.black : Colors.white;

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      buildWhen: (_, state) => state is AuthFetchedUserProfileState,
      builder: (context, state) {
        UserProfileResponse userProfile = authBloc.userProfile;

        return SafeArea(
          bottom: false,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.mediumSpacing,
              vertical: AppDimensions.smallSpacing,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      const _ShopHomeAvatar(),
                      AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                      Expanded(
                        child: PrimaryText(
                          "${"hello".tr()}\n${userProfile.displayName}",
                          overflow: TextOverflow.ellipsis,
                          color: contentColor,
                          style: AppTextStyles.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                const ShopSelectionButton(),
              ],
            ),
          ),
        );
      },
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
        getIt
            .get<ShopMasterBloc>()
            .changeTab(BottomNavigationItem.menu);
      },
      child: const PrimaryAssetAvatar(
        image: ImagePath.shopHomeAvatar,
        backgroundImage: ImagePath.shopHomeAvatarBackground,
        radius: AppDimensions.homeAvatarRadius,
      ),
    );
  }
}
