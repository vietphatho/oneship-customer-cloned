import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/map_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

abstract class OrderDetailMapEvent {
  const OrderDetailMapEvent();
}

class OrderDetailMapResolvedEvent extends OrderDetailMapEvent {
  const OrderDetailMapResolvedEvent({
    required this.orderDetail,
    required this.shop,
  });

  final OrderDetailEntity? orderDetail;
  final BriefShopEntity? shop;
}

class OrderDetailMapMarkerSelectedEvent extends OrderDetailMapEvent {
  const OrderDetailMapMarkerSelectedEvent({required this.marker});

  final OrderDetailMapMarkerType marker;
}

class OrderDetailMapMarkerDismissedEvent extends OrderDetailMapEvent {
  const OrderDetailMapMarkerDismissedEvent();
}
