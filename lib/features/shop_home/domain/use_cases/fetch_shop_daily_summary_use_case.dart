import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@lazySingleton
class FetchShopDailySummaryUseCase {
  final ShopRepository _repository;

  FetchShopDailySummaryUseCase(this._repository);

  Future<Resource<ShopDailySummaryEntity>> call(String shopId) {
    return _repository.fetchShopDailySummary(shopId);
  }
}
