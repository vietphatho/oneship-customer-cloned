import 'package:collection/collection.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';

class ResolveOrderDetailVendorUseCase {
  const ResolveOrderDetailVendorUseCase();

  ShopVendorEntity? call({
    required OrderDetailEntity? order,
    required List<ShopVendorEntity> vendors,
  }) {
    if (order?.externalType != ExternalType.vendor) return null;

    final externalId = order?.externalId?.trim();
    if (externalId == null || externalId.isEmpty) return null;

    return vendors.firstWhereOrNull((vendor) => vendor.userId == externalId);
  }
}
