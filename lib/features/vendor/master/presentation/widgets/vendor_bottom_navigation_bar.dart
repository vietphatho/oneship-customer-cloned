import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/master/data/vendor_navigation_item.dart';
import 'package:oneship_customer/features/vendor/master/presentation/bloc/vendor_master_bloc.dart';
import 'package:oneship_customer/features/vendor/master/presentation/bloc/vendor_master_state.dart';

class VendorBottomNavigationBar extends StatefulWidget {
  const VendorBottomNavigationBar({super.key});

  @override
  State<VendorBottomNavigationBar> createState() =>
      _VendorBottomNavigationBarState();
}

class _VendorBottomNavigationBarState extends State<VendorBottomNavigationBar> {
  final VendorMasterBloc _vendorMasterBloc = getIt.get();

  static const _items = [
    VendorNavigationItem.home,
    VendorNavigationItem.orders,
    VendorNavigationItem.wallet,
    VendorNavigationItem.profile,
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocBuilder<VendorMasterBloc, VendorMasterState>(
      bloc: _vendorMasterBloc,
      builder: (context, state) {
        return Container(
          // color: Colors.transparent,
          height: AppDimensions.bottomNavBarHeight + bottomInset,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 32,
                spreadRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.xxLargeRadius),
              topRight: Radius.circular(AppDimensions.xxLargeRadius),
            ),
          ),
          padding: EdgeInsets.only(
            left: AppDimensions.mediumSpacing,
            right: AppDimensions.mediumSpacing,
            bottom: bottomInset,
          ),
          child: Row(
            children: _items
                .map(
                  (item) => Expanded(
                    child: _NavigationItem(
                      item: item,
                      isSelected: _vendorMasterBloc.currentTab == item,
                      onTap: _onItemTapped,
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _onItemTapped(VendorNavigationItem item) {
    _vendorMasterBloc.changeTab(item);
    final location = GoRouterState.of(context).matchedLocation;
    if (location != RouteName.vendorMasterPage) {
      context.go(RouteName.vendorMasterPage);
    }
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  final VendorNavigationItem item;
  final bool isSelected;
  final void Function(VendorNavigationItem item)? onTap;

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
