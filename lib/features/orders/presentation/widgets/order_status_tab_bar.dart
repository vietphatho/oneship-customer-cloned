import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_customer/core/base/components/icon_label_tab_bar.dart';
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
    return IconLabelTabBar(
      controller: controller,
      onTap: onTap,
      items: items
          .map(
            (status) => IconLabelTabItem(
              label: status.value.tr(),
              iconPath: status.iconPath,
            ),
          )
          .toList(),
    );
  }
}
