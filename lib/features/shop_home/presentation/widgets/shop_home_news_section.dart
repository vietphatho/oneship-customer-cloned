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

class ShopHomeNewsSection extends StatelessWidget {
  const ShopHomeNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final postBloc = getIt.get<PostBloc>();

    return BlocBuilder<PostBloc, PostState>(
      bloc: postBloc,
      buildWhen: (previous, current) =>
          previous.newsResource != current.newsResource ||
          previous.listNews != current.listNews,
      builder: (context, state) {
        final news = state.homeNews;
        final isLoading =
            state.newsResource.state == Result.loading && news.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: PrimaryText(
                    'shop_home.news'.tr(),
                    style: AppTextStyles.titleSmall,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.push(RouteName.newsPage),
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
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            if (isLoading)
              const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (news.isEmpty)
              SizedBox(
                height: 140,
                child: PrimaryEmptyData(onRetry: postBloc.fetchNews),
              )
            else
              Column(
                children: [
                  for (final article in news) ...[
                    ShopHomeArticleCard(
                      article: article,
                      showDate: true,
                      layout: ShopHomeArticleCardLayout.horizontal,
                    ),
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
                  ],
                ],
              ),
          ],
        );
      },
    );
  }
}
