import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ShopSelectionPage extends StatefulWidget {
  const ShopSelectionPage({super.key});

  @override
  State<ShopSelectionPage> createState() => _ShopSelectionPageState();
}

class _ShopSelectionPageState extends State<ShopSelectionPage> {
  final RefreshController _refreshController = RefreshController();
  final ShopBloc _shopBloc = getIt.get();

  @override
  void dispose() {
    _refreshController.dispose();
    _shopBloc.changeDraftSelectedShop(_shopBloc.state.currentShop!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "select_shop".tr()),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ShopBloc, ShopState>(
              bloc: _shopBloc,
              listenWhen: (previous, current) =>
                  previous.briefShopsResource != current.briefShopsResource,
              listener: _listenBriefListChanged,
              builder: (context, state) {
                final shops = state.listBriefShops;

                return PrimaryRefreshabelListView(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  enablePullUp: true,
                  padding: AppDimensions.smallPaddingHorizontal,
                  itemCount: shops.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return _ShopItem(index: index + 1, shop: shops[index]);
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: AppDimensions.mediumPaddingAll,
              child: SecondaryButton.filled(
                label: 'confirm'.tr(),
                onPressed: () {
                  if (_shopBloc.state.draftSelectedShop !=
                      _shopBloc.state.currentShop) {
                    _shopBloc.changeShop(_shopBloc.state.draftSelectedShop!);
                  }
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onRefresh() {
    _shopBloc.fetchBriefShop();
  }

  void _onLoading() {
    if (!_shopBloc.state.hasNext) {
      _refreshController.loadNoData();
      return;
    }

    _shopBloc.loadMoreBriefShop();
  }

  void _listenBriefListChanged(BuildContext context, ShopState state) {
    switch (state.briefShopsResource.state) {
      case Result.success:
        _refreshController
          ..refreshCompleted()
          ..loadComplete();
        break;
      case Result.error:
        _refreshController
          ..refreshFailed()
          ..loadFailed();
      default:
    }
  }
}

class _ShopItem extends StatelessWidget {
  const _ShopItem({required this.index, required this.shop});

  final int index;
  final BriefShopEntity shop;

  @override
  Widget build(BuildContext context) {
    final ShopBloc shopBloc = getIt.get();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen: (previous, current) =>
          previous.draftSelectedShop != current.draftSelectedShop,
      builder: (context, state) {
        final isSelected = state.draftSelectedShop?.shopId == shop.shopId
            ? true
            : false;
        return PrimaryAnimatedPressableWidget(
          onTap: () {
            if (isSelected) return;
            shopBloc.changeDraftSelectedShop(shop);
          },
          child: Padding(
            padding: AppDimensions.mediumPaddingVertical,
            child: Row(
              children: [
                PrimaryText(
                  '$index.',
                  style: AppTextStyles.labelLarge,
                  color: isSelected ? AppColors.primary : AppColors.neutral6,
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                Expanded(
                  child: PrimaryText(
                    shop.shopName.tr(),
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge,
                    color: isSelected ? AppColors.primary : AppColors.neutral6,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                if (isSelected) Icon(Icons.check, color: AppColors.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
