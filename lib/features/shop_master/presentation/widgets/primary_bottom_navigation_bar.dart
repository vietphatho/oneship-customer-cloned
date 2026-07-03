import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
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
  final AuthBloc _authBloc = getIt.get();

  late final List<BottomNavigationItem> _bottomNavBarList;

  @override
  void initState() {
    super.initState();
    _bottomNavBarList = _authBloc.getBottomNavBarList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navigationGeometry = _BottomNavigationBarGeometry(
      bottomInset: bottomInset,
    );

    return BlocBuilder<ShopMasterBloc, ShopMasterState>(
      bloc: _shopMasterBloc,
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          height: navigationGeometry.totalHeight,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 32,
                        spreadRadius: 20,
                        offset: const Offset(0, -8),
                      ),
                    ],
                    color: Colors.transparent,
                  ),
                  child: ClipPath(
                    clipper: _BottomNavigationBarClipper(
                      geometry: navigationGeometry,
                    ),
                    child: Container(
                      height: navigationGeometry.barHeight,
                      padding: EdgeInsets.only(
                        left: AppDimensions.mediumSpacing,
                        right: AppDimensions.mediumSpacing,
                        bottom: navigationGeometry.bottomInset,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimensions.xxLargeRadius),
                          topRight: Radius.circular(
                            AppDimensions.xxLargeRadius,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _NavigationItem(
                              item: _bottomNavBarList[0],
                              isSelected:
                                  _shopMasterBloc.currentTab ==
                                  _bottomNavBarList[0],
                              onTap: _onItemTapped,
                            ),
                          ),
                          Expanded(
                            child: _NavigationItem(
                              item: _bottomNavBarList[1],
                              isSelected:
                                  _shopMasterBloc.currentTab ==
                                  _bottomNavBarList[1],
                              onTap: _onItemTapped,
                            ),
                          ),
                          SizedBox(width: navigationGeometry.centerButtonSize),
                          Expanded(
                            child: _NavigationItem(
                              item: _bottomNavBarList[2],
                              isSelected:
                                  _shopMasterBloc.currentTab ==
                                  _bottomNavBarList[2],
                              onTap: _onItemTapped,
                            ),
                          ),
                          Expanded(
                            child: _NavigationItem(
                              item: _bottomNavBarList[3],
                              isSelected:
                                  _shopMasterBloc.currentTab ==
                                  _bottomNavBarList[3],
                              onTap: _onItemTapped,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: navigationGeometry.centerButtonTop,
                left: 0,
                right: 0,
                child: _CenterNavigationItem(
                  item: BottomNavigationItem.createOrder,
                  geometry: navigationGeometry,
                  // isSelected:
                  //     _shopMasterBloc.currentTab == BottomNavigationItem.home,
                  onTap: () {
                    context.push(RouteName.createOrderPage);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onItemTapped(BottomNavigationItem item) {
    _shopMasterBloc.changeTab(item);
    final String location = GoRouterState.of(context).matchedLocation;
    if (location != RouteName.shopMasterPage) {
      context.go(RouteName.shopMasterPage);
    }
  }
}

class _CenterNavigationItem extends StatelessWidget {
  final BottomNavigationItem item;
  final _BottomNavigationBarGeometry geometry;
  final VoidCallback onTap;

  const _CenterNavigationItem({
    required this.item,
    required this.geometry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryAnimatedPressableWidget(
        onTap: onTap,
        child: Container(
          width: geometry.centerButtonSize,
          height: geometry.centerButtonSize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: PrimaryBoxShadows.bottomNavShadow,
          ),
          child: Center(
            child: SizedBox(
              width: AppDimensions.smallIconSize,
              height: AppDimensions.smallIconSize,
              child: SvgPicture.asset(
                item.icon,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
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
            SvgPicture.asset(
              item.icon,
              width: AppDimensions.smallIconSize,
              height: AppDimensions.smallIconSize,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primary : AppColors.neutral7,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: AppDimensions.xxxSmallSpacing),
            PrimaryText(
              item.title,
              style: AppTextStyles.labelSmall.copyWith(
                fontSize: 10,
                color: isSelected ? AppColors.primary : AppColors.neutral7,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationBarGeometry {
  final double bottomInset;

  const _BottomNavigationBarGeometry({required this.bottomInset});

  double get barContentHeight => AppDimensions.bottomNavBarHeight;
  double get centerButtonSize => AppDimensions.centerButtonNavHeight;
  double get centerButtonRadius => centerButtonSize / 2;
  double get notchClearance => AppDimensions.mediumSpacing;
  double get notchShoulderPadding => AppDimensions.mediumSpacing;
  double get notchEntryDepth => centerButtonRadius / 4;

  double get totalHeight => AppDimensions.safeBottomSpacing + bottomInset;
  double get barHeight => barContentHeight + bottomInset;
  double get barTop => totalHeight - barHeight;

  double get centerButtonCenterYInBar => centerButtonRadius - barTop;
  double get centerButtonTop =>
      barTop + centerButtonCenterYInBar - centerButtonRadius;

  double get notchDepth =>
      centerButtonCenterYInBar + centerButtonRadius + notchClearance;

  double get notchRadius => centerButtonRadius + notchClearance;
  double get notchShoulderRadius => notchRadius + notchShoulderPadding;
}

class _BottomNavigationBarClipper extends CustomClipper<Path> {
  final _BottomNavigationBarGeometry geometry;

  const _BottomNavigationBarClipper({required this.geometry});

  @override
  Path getClip(Size size) {
    final centerX = size.width / 2;
    final notchRadius = geometry.notchRadius;
    final notchShoulderRadius = geometry.notchShoulderRadius;
    final notchEntryDepth = geometry.notchEntryDepth;
    final barContentHeight = size.height - geometry.bottomInset;
    final notchDepth = geometry.notchDepth
        .clamp(notchEntryDepth, barContentHeight)
        .toDouble();

    return Path()
      ..moveTo(0, 0)
      ..lineTo(centerX - notchShoulderRadius, 0)
      ..quadraticBezierTo(
        centerX - notchRadius,
        0,
        centerX - notchRadius,
        notchEntryDepth,
      )
      ..cubicTo(
        centerX - notchRadius / 2,
        notchDepth,
        centerX + notchRadius / 2,
        notchDepth,
        centerX + notchRadius,
        notchEntryDepth,
      )
      ..quadraticBezierTo(
        centerX + notchRadius,
        0,
        centerX + notchShoulderRadius,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _BottomNavigationBarClipper oldClipper) {
    return oldClipper.geometry.bottomInset != geometry.bottomInset;
  }
}
