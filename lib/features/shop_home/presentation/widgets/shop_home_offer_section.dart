import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/post_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/post_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/promotion_program_card.dart';

class ShopHomeOfferSection extends StatelessWidget {
  const ShopHomeOfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    final postBloc = getIt.get<PostBloc>();

    return BlocBuilder<PostBloc, PostState>(
      bloc: postBloc,
      buildWhen: (previous, current) =>
          previous.promotionsResource != current.promotionsResource ||
          previous.listPromotions != current.listPromotions,
      builder: (context, state) {
        final promotions = state.homePromotions;
        final isLoading =
            state.promotionsResource.state == Result.loading &&
            promotions.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'shop_home.offers'.tr(),
              onViewAll: () => context.push(RouteName.promotionsPage),
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            if (isLoading)
              const SizedBox(
                height: 92,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (promotions.isEmpty)
              SizedBox(
                height: 140,
                child: PrimaryEmptyData(onRetry: postBloc.fetchPromotions),
              )
            else
              SizedBox(
                height: PromotionProgramCard.homeListHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: promotions.length,
                  separatorBuilder: (context, index) =>
                      AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                  itemBuilder: (context, index) {
                    return PromotionProgramCard(
                      promotion: promotions[index],
                      width: 180,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onViewAll});

  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: PrimaryText(title, style: AppTextStyles.titleSmall)),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onViewAll,
          child: Padding(
            padding: AppDimensions.xxSmallPaddingAll,
            child: PrimaryText(
              'shop_home.view_more'.tr(),
              style: AppTextStyles.titleSmall,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
