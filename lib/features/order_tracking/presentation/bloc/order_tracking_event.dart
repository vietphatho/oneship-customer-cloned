abstract class OrderTrackingEvent {
  const OrderTrackingEvent();
}

class OrderTrackingSearchEvent extends OrderTrackingEvent {
  final String trackingNumber;

  OrderTrackingSearchEvent(this.trackingNumber);
}

class OrderTrackingResetDataEvent extends OrderTrackingEvent {
  OrderTrackingResetDataEvent();
}
