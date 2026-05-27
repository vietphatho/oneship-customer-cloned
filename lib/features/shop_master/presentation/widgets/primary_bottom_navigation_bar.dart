import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
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

  static const List<BottomNavigationItem> _sideItems = [
    BottomNavigationItem.finance,
    BottomNavigationItem.staffManagement,
    BottomNavigationItem.shopManagement,
    BottomNavigationItem.menu,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopMasterBloc, ShopMasterState>(
      bloc: _shopMasterBloc,
      builder: (context, state) {
        return SafeArea(
          child: SizedBox(
            height: AppDimensions.safeBottomSpacing,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PhysicalShape(
                    color: AppColors.neutral9,
                    clipper: _BottomNavigationBarClipper(),
                    elevation: AppDimensions.xSmallSpacing,
                    shadowColor: AppColors.neutral7,
                    child: Container(
                      height: AppDimensions.bottomNavBarHeight,
                      padding: AppDimensions.largePaddingHorizontal,
                      child: Row(
                        children: [
                          Expanded(
                            child: _NavigationItem(
                              item: _sideItems[0],
                              isSelected:
                                  _shopMasterBloc.currentTab == _sideItems[0],
                              onTap: _onItemTapped,
                            ),
                          ),
                          Expanded(
                            child: _NavigationItem(
                              item: _sideItems[1],
                              isSelected:
                                  _shopMasterBloc.currentTab == _sideItems[1],
                              onTap: _onItemTapped,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.displayIconSize),
                          Expanded(
                            child: _NavigationItem(
                              item: _sideItems[2],
                              isSelected:
                                  _shopMasterBloc.currentTab == _sideItems[2],
                              onTap: _onItemTapped,
                            ),
                          ),
                          Expanded(
                            child: _NavigationItem(
                              item: _sideItems[3],
                              isSelected:
                                  _shopMasterBloc.currentTab == _sideItems[3],
                              onTap: _onItemTapped,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _CenterNavigationItem(
                    item: BottomNavigationItem.home,
                    isSelected:
                        _shopMasterBloc.currentTab == BottomNavigationItem.home,
                    onTap: _onItemTapped,
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

class _CenterNavigationItem extends StatelessWidget {
  final BottomNavigationItem item;
  final void Function(BottomNavigationItem item)? onTap;
  final bool isSelected;

  const _CenterNavigationItem({
    required this.item,
    this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: () => onTap?.call(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: AppDimensions.bottomNavBarHeight,
        height: AppDimensions.bottomNavBarHeight,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.neutral8,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              spreadRadius: AppDimensions.xSmallSpacing,
              blurRadius: AppDimensions.xSmallSpacing,
            ),
            BoxShadow(
              color: AppColors.neutral8,
              offset: Offset(0, AppDimensions.xSmallSpacing),
              blurRadius: AppDimensions.mediumSpacing,
            ),
          ],
        ),
        child: Icon(
          item.icon,
          size: AppDimensions.largeIconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final BottomNavigationItem item;
  final void Function(BottomNavigationItem item)? onTap;
  final bool isSelected;

  const _NavigationItem({
    required this.item,
    this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: () => onTap?.call(item),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size:
                  isSelected
                      ? AppDimensions.mediumIconSize +
                          AppDimensions.xxSmallSpacing
                      : AppDimensions.mediumIconSize,
              color: isSelected ? AppColors.primary : AppColors.neutral5,
            ),
            AppSpacing.vertical(AppDimensions.xxSmallSpacing),
            PrimaryText(
              item.navLabelKey.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.neutral5,
                fontSize: isSelected ? 13 : 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _BottomNavigationItemLabel on BottomNavigationItem {
  String get navLabelKey {
    switch (this) {
      case BottomNavigationItem.home:
        return 'bottom_navigation.home';
      case BottomNavigationItem.finance:
        return 'bottom_navigation.finance';
      case BottomNavigationItem.staffManagement:
        return 'bottom_navigation.staff';
      case BottomNavigationItem.shopManagement:
        return 'bottom_navigation.shop';
      case BottomNavigationItem.menu:
        return 'bottom_navigation.more';
    }
  }
}

class _BottomNavigationBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.30, 0)
      ..quadraticBezierTo(
        size.width * 0.375,
        0,
        size.width * 0.375,
        size.height * 0.10,
      )
      ..cubicTo(
        size.width * 0.40,
        size.height * 0.90,
        size.width * 0.60,
        size.height * 0.90,
        size.width * 0.625,
        size.height * 0.10,
      )
      ..quadraticBezierTo(
        size.width * 0.625,
        0,
        size.width * 0.70,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
