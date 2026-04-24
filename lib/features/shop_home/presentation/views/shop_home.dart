import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/create_shop_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_app_bar.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_brief_info.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_empty_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_home_feature_button.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  static const double _bottomSpacing = 96;

  final ShopBloc _shopBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    // _shopBloc.init(shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(gradient: AppColors.shopHomeGradBg),
        ),
        Column(
          children: [
            const ShopAppBar(),
            Expanded(
              child: BlocBuilder<ShopBloc, ShopState>(
                bloc: _shopBloc,
                buildWhen:
                    (previous, current) =>
                        previous.shopsResource != current.shopsResource ||
                        previous.userId != current.userId,
                builder: (context, state) {
                  switch (state.shopsResource.state) {
                    case Result.loading:
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    case Result.error:
                      return _ShopHomeErrorState(
                        message:
                            state.shopsResource.message.isEmpty
                                ? 'Không thể tải danh sách cửa hàng.'
                                : state.shopsResource.message,
                        onRetry: () => _shopBloc.init(state.userId),
                      );
                    case Result.success:
                      if (state.shops.isEmpty) {
                        return ShopEmptyState(
                          onCreateShopPressed:
                              () => _openCreateShopPage(context),
                        );
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: _bottomSpacing),
                        child: Column(
                          children: [
                            AppSpacing.vertical(AppDimensions.smallSpacing),
                            const ShopBriefInfo(),
                            GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2 / 1,
                                    mainAxisSpacing: AppDimensions.smallSpacing,
                                    crossAxisSpacing:
                                        AppDimensions.smallSpacing,
                                  ),
                              itemCount: ShopHomeFeature.values.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.mediumSpacing,
                                vertical: AppDimensions.smallSpacing,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (context, index) => ShopHomeFeatureButton(
                                    feature: ShopHomeFeature.values[index],
                                  ),
                            ),
                          ],
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openCreateShopPage(BuildContext context) async {
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => const CreateShopPage()));
  }
}

class _ShopHomeErrorState extends StatelessWidget {
  const _ShopHomeErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.largeSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.store_mall_directory_outlined,
              size: AppDimensions.displayIconSize,
              color: AppColors.primary,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            PrimaryText(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
              color: AppColors.neutral3,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            PrimaryButton.primary(label: 'Tải lại', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
