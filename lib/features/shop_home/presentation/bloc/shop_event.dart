import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_params.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

abstract class ShopEvent {
  const ShopEvent();
}

class ShopFetchDailySummaryEvent extends ShopEvent {
  final String shopId;

  const ShopFetchDailySummaryEvent(this.shopId);
}

class ShopFetchBriefListEvent extends ShopEvent {
  final String userId;

  const ShopFetchBriefListEvent(this.userId);
}

class ShopFetchDataEvent extends ShopEvent {
  const ShopFetchDataEvent();
}

class ShopLoadMoreDataEvent extends ShopEvent {
  const ShopLoadMoreDataEvent();
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
  final BriefShopEntity shop;

  ShopChangeEvent(this.shop);
}

class ShopSearchEvent extends ShopEvent {
  final String query;

  const ShopSearchEvent(this.query);
}
