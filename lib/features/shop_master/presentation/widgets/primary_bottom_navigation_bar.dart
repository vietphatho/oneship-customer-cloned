import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/liquid_glass_view.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
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
              vertical: AppDimensions.smallSpacing,
            ),
            child: LiquidGlassView(
              borderRadius: AppDimensions.xLargeBorderRadius,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppDimensions.xxxSmallSpacing,
                  horizontal: AppDimensions.mediumSpacing,
                ),

                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   boxShadow: PrimaryBoxShadows.bottomNavShadow,
                //   borderRadius: AppDimensions.xLargeBorderRadius,
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      BottomNavigationItem.values
                          .map(
                            (item) => _NavigationItem(
                              item: item,
                              isSelected: _shopMasterBloc.currentTab == item,
                              onTap: _onItemTapped,
                            ),
                          )
                          .toList(),
                ),
              ),
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
    return PrimaryAnimatedPressableWidget(
      onTap: () => onTap?.call(item),
      child: LiquidGlassView(
        isEnable: isSelected,
        backgroundColor: AppColors.primary,
        opacity: 0.9,
        borderRadius: AppDimensions.xLargeBorderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
            vertical: AppDimensions.smallSpacing,
          ),
          child: Icon(
            item.icon,
            size: AppDimensions.mediumIconSize,
            color: isSelected ? Colors.white : AppColors.neutral3,
          ),
        ),
      ),
    );
  }
}
