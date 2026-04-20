import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/shop_selection_button.dart';

class ShopMasterAppBar extends StatelessWidget {
  const ShopMasterAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _authBloc = getIt.get<AuthBloc>();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      buildWhen: (_, state) => state is AuthFetchedUserProfileState,
      builder: (context, state) {
        UserProfileResponse userProfile = _authBloc.userProfile;

        return SafeArea(
          bottom: false,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.mediumSpacing,
              vertical: AppDimensions.smallSpacing,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: AppDimensions.homeAvatarRadius,
                      foregroundImage: CachedNetworkImageProvider(
                        userProfile.avatarUrl ?? "",
                      ),
                      backgroundColor: AppColors.neutral7,
                    ),
                    AppSpacing.horizontal(AppDimensions.smallSpacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryText(userProfile.displayName),
                          PrimaryText(userProfile.userEmail),
                        ],
                      ),
                    ),
                    // AppSpacing.horizontal(AppDimensions.smallSpacing),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(
                    //     Icons.post_add_rounded,
                    //     size: AppDimensions.mediumIconSize,
                    //   ),
                    // ),
                    EndDrawerButton(),
                  ],
                ),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const ShopSelectionButton(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
