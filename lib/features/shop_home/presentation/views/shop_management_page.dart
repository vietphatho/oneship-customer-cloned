import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_spacing.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_card.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_management_empty_view.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_management_header.dart';

class ShopManagementPage extends StatefulWidget {
  const ShopManagementPage({super.key});

  @override
  State<ShopManagementPage> createState() => _ShopManagementPageState();
}

class _ShopManagementPageState extends State<ShopManagementPage> {
  final ShopBloc _shopBloc = getIt.get();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      bloc: _shopBloc,
      builder: (context, state) {
        final isLoading = state.shopsResource.state == Result.loading;
        final allShops = state.shopsResource.data?.data ?? [];
        final displayShops = state.filteredShops.isEmpty && allShops.isNotEmpty
            ? allShops
            : state.filteredShops;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                ShopManagementHeader(
                  totalCount: allShops.length,
                  searchController: _searchController,
                  onSearchChanged: _shopBloc.searchShops,
                  onAddShopPressed: _onAddShop,
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : allShops.isEmpty
                          ? const ShopManagementEmptyView()
                          : _buildShopList(displayShops),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShopList(List displayShops) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumSpacing,
        vertical: AppDimensions.smallSpacing,
      ),
      itemCount: displayShops.length,
      separatorBuilder: (_, __) => AppSpacing.vertical(12),
      itemBuilder: (context, index) => ShopCard(
        index: index + 1,
        shop: displayShops[index],
      ),
    );
  }

  void _onAddShop() {
    // TODO: navigate to create shop page
  }
}
