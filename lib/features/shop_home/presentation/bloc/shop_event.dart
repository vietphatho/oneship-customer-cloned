import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_params.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';

abstract class ShopEvent {
  const ShopEvent();
}

class ShopFetchDailySummaryEvent extends ShopEvent {
  final String shopId;

  const ShopFetchDailySummaryEvent(this.shopId);
}

class ShopFetchListEvent extends ShopEvent {
  final String userId;

  const ShopFetchListEvent(this.userId);
}

class ShopInitDataEvent extends ShopEvent {
  final String userId;

  const ShopInitDataEvent(this.userId);
}

class ShopCreateEvent extends ShopEvent {
  const ShopCreateEvent(this.params);

  final CreateShopParams params;
}

class ShopChangeEvent extends ShopEvent {
  final ShopEntity shop;

  ShopChangeEvent(this.shop);
}
