import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_card.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ShopManagementPage extends StatefulWidget {
  const ShopManagementPage({super.key});

  @override
  State<ShopManagementPage> createState() => _ShopManagementPageState();
}

class _ShopManagementPageState extends State<ShopManagementPage> {
  final ShopBloc _shopBloc = getIt.get();
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ShopBloc, ShopState>(
          bloc: _shopBloc,
          listenWhen:
              (previous, current) =>
                  previous.shopsResource != current.shopsResource,
          listener: _listenLoadShopsState,
        ),
      ],
      child: BlocBuilder<ShopBloc, ShopState>(
        bloc: _shopBloc,
        builder: (context, state) {
          // final allShops = state.briefShopsResource.data?.data ?? [];
          // final displayShops =
          //     state.filteredShops.isEmpty && allShops.isNotEmpty
          //         ? allShops
          //         : state.filteredShops;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: PrimaryAppBar(
              title: "shop".tr(),
              canPop: false,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.add_circled_solid),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  _Header(
                    searchController: _searchController,
                    onSearchChanged: _shopBloc.searchShops,
                  ),
                  Expanded(
                    child: PrimaryRefreshabelListView(
                      controller: _refreshController,
                      padding: EdgeInsets.fromLTRB(
                        AppDimensions.smallSpacing,
                        AppDimensions.smallSpacing,
                        AppDimensions.smallSpacing,
                        AppDimensions.bottomNavBarHeight +
                            AppDimensions.smallSpacing,
                      ),
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      itemBuilder:
                          (context, index) => ShopCard(
                            index: index + 1,
                            shop: state.shopsList[index],
                          ),
                      separatorBuilder:
                          (context, index) =>
                              AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      itemCount: state.shopsList.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onAddShop() {
    // TODO: navigate to create shop page
  }

  void _onRefresh() {
    _shopBloc.fetchShop();
  }

  void _onLoading() {
    if (_shopBloc.state.shopsResource.data?.hasMoreData != true) {
      _refreshController.loadNoData();
      return;
    }
    _shopBloc.loadMore();
  }

  void _listenLoadShopsState(BuildContext context, ShopState state) {
    switch (state.shopsResource.state) {
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

class _Header extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const _Header({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.smallSpacing,
      ),
      child: PrimaryTextField(
        controller: searchController,
        onChanged: onSearchChanged,
        hintText: 'shop_management.search_hint'.tr(),
      ),
    );
  }
}
