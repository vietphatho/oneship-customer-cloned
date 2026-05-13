import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_map_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

@lazySingleton
class ResolveOrderDetailMapUseCase {
  OrderDetailMapEntity call({
    required OrderDetailEntity? orderDetail,
    required BriefShopEntity? shop,
  }) {
    return OrderDetailMapEntity(
      shopLatLong: shop?.shopCoordinates?.latLong,
      deliveryLatLong: orderDetail?.coordinates?.latLong,
      shopAddress: orderDetail?.shop?.profile?.fullAddress ?? shop?.address,
      deliveryAddress: orderDetail?.fullAddress,
    );
  }
}
