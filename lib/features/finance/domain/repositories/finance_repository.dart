import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';

abstract class FinanceRepository extends BaseRepository {
  Future<Resource<FinanceEntity>> fetchShopFinancial({
    required String shopId,
    required String startDate,
    required String endDate,
  });
}
