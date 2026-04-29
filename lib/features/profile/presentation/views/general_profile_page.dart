import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';

class GeneralProfilePage extends StatelessWidget {
  const GeneralProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [const _Header()]));
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = getIt.get();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      builder: (context, state) {
        var userProfile = _authBloc.userProfile;

        return PrimaryCard(
          child: Row(
            children: [
              CircleAvatar(radius: AppDimensions.defaultAvatarRadius),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    userProfile.displayName,
                    style: AppTextStyles.displaySmall,
                  ),
                  PrimaryText(
                    userProfile.userPhone,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: AppDimensions.mediumBorderRadius,
                ),
                child: PrimaryText(
                  "online".tr(),
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
