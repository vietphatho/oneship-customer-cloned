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
