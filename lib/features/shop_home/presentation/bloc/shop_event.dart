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

  ShopInitDataEvent(this.userId);
}

class ShopChangeEvent extends ShopEvent {
  final ShopEntity shop;

  ShopChangeEvent(this.shop);
}

class ShopSearchEvent extends ShopEvent {
  final String query;

  const ShopSearchEvent(this.query);
}
