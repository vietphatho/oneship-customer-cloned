import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';

abstract class ShopStaffEvent {
  const ShopStaffEvent();
}

class ShopStaffInitEvent extends ShopStaffEvent {
  const ShopStaffInitEvent(this.shop);

  final BriefShopEntity shop;
}

class ShopStaffFetchEvent extends ShopStaffEvent {
  const ShopStaffFetchEvent({this.refresh = false});

  final bool refresh;
}

class ShopStaffFilterEvent extends ShopStaffEvent {
  const ShopStaffFilterEvent({
    this.displayName,
    this.userEmail,
    this.userStatus,
  });

  final String? displayName;
  final String? userEmail;
  final String? userStatus;
}

class ShopStaffLoadMoreEvent extends ShopStaffEvent {
  const ShopStaffLoadMoreEvent();
}

class ShopStaffCreateEvent extends ShopStaffEvent {
  const ShopStaffCreateEvent(this.request);

  final CreateShopStaffRequest request;
}

class ShopStaffToggleDisableEvent extends ShopStaffEvent {
  const ShopStaffToggleDisableEvent({
    required this.shopId,
    required this.staffId,
  });

  final String shopId;
  final String staffId;
}

class ShopStaffFetchDetailEvent extends ShopStaffEvent {
  const ShopStaffFetchDetailEvent({
    required this.shopId,
    required this.staffId,
  });

  final String shopId;
  final String staffId;
}

class ShopStaffAddToShopEvent extends ShopStaffEvent {
  const ShopStaffAddToShopEvent({
    required this.shopId,
    required this.userId,
    required this.permissions,
  });

  final String shopId;
  final String userId;
  final Map<String, Map<String, bool>> permissions;
}
