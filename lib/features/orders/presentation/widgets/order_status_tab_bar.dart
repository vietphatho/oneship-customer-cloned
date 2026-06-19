import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';

extension OrderStatusIconExt on OrderStatus {
  String get iconPath {
    switch (this) {
      case OrderStatus.atHub:
        return 'assets/icons/ic_status_at_hub.svg';
      case OrderStatus.pending:
        return 'assets/icons/ic_status_pending.svg';
      case OrderStatus.processing:
        return 'assets/icons/ic_status_created.svg';
      case OrderStatus.batched:
        return 'assets/icons/ic_status_packed.svg';
      case OrderStatus.shipping:
        return 'assets/icons/ic_status_delivering.png';
      case OrderStatus.delayed:
        return 'assets/icons/ic_status_delayed.png';
      case OrderStatus.cancelled:
      case OrderStatus.deleted:
        return 'assets/icons/ic_status_cancelled.svg';
      case OrderStatus.returned:
      case OrderStatus.returnInProgress:
        return 'assets/icons/ic_status_returning.svg';
      case OrderStatus.allProcessing:
      default:
        return 'assets/icons/ic_status_all.svg';
    }
  }

  Widget buildIcon({double width = 24, double height = 24, Color? color}) {
    final path = iconPath;
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(path, width: width, height: height, color: color);
    } else {
      return Image.asset(path, width: width, height: height, color: color);
    }
  }
}

class OrderStatusTabBar extends StatelessWidget {
  const OrderStatusTabBar({
    super.key,
    this.onTap,
    required this.items,
    required this.controller,
  });

  final List<OrderStatus> items;
  final void Function(int)? onTap;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.smallSpacing,
        AppDimensions.xxSmallSpacing,
        AppDimensions.smallSpacing,
        AppDimensions.xSmallSpacing,
      ),
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.largeBorderRadius,
          border: Border.all(color: AppColors.shopHomeV2InputBorder),
        ),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    _OrderStatusTabItem(
                      status: items[index],
                      isSelected: controller.index == index,
                      onTap: () {
                        onTap?.call(index);
                        controller.animateTo(index);
                      },
                    ),
                    if (index != items.length - 1) AppSpacing.horizontal(4),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderStatusTabItem extends StatelessWidget {
  const _OrderStatusTabItem({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  final OrderStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.neutral5;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.mediumBorderRadius,
      child: Container(
        constraints: const BoxConstraints(minWidth: 76),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.shopHomeV2SelectedTabBackground
              : Colors.transparent,
          borderRadius: AppDimensions.mediumBorderRadius,
          border: isSelected
              ? Border.all(color: AppColors.shopHomeV2SelectedTabBorder)
              : null,
        ),
        child: PrimaryText(
          status.value.tr(),
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelXSmall.copyWith(
            color: color,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
