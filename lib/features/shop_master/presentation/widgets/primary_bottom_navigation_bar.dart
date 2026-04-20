import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_spacing.dart';
import 'package:oneship_customer/core/themes/primary_box_shadows.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_state.dart';

class PrimaryBottomNavigationBar extends StatefulWidget {
  const PrimaryBottomNavigationBar({super.key});

  @override
  State<PrimaryBottomNavigationBar> createState() =>
      _PrimaryBottomNavigationBarState();
}

class _PrimaryBottomNavigationBarState
    extends State<PrimaryBottomNavigationBar> {
  final ShopMasterBloc _shopMasterBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopMasterBloc, ShopMasterState>(
      bloc: _shopMasterBloc,
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.mediumSpacing,
              vertical: AppDimensions.mediumSpacing,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.xSmallSpacing,
                      horizontal: AppDimensions.mediumSpacing,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: PrimaryBoxShadows.bottomNavShadow,
                      borderRadius: AppDimensions.xLargeBorderRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          BottomNavigationItem.values
                              .map(
                                (item) => _NavigationItem(
                                  item: item,
                                  isSelected:
                                      _shopMasterBloc.currentTab == item,
                                  onTap: _onItemTapped,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.largeSpacing),
                PrimaryAnimatedPressableWidget(
                  onTap: () {
                    context.push(RouteName.createOrderPage);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.mediumSpacing,
                      horizontal: AppDimensions.mediumSpacing,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: PrimaryBoxShadows.bottomNavShadow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.add,
                      size: AppDimensions.largeIconSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(BottomNavigationItem item) {
    _shopMasterBloc.changeTab(item);
  }
}

class _NavigationItem extends StatelessWidget {
  final BottomNavigationItem item;
  final void Function(BottomNavigationItem item)? onTap;
  final bool isSelected;

  const _NavigationItem({
    super.key,
    required this.item,
    this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onTap?.call(item),
      icon: Container(
        child: Icon(item.icon, size: AppDimensions.largeIconSize),
      ),
    );
  }
}
