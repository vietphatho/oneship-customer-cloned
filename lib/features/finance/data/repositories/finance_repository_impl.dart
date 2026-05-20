import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/data/datasources/finance_api.dart';
import 'package:oneship_customer/features/finance/data/models/response/finance_response.dart';
import 'package:oneship_customer/features/finance/data/models/response/settlement_periods_response.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/finance/domain/repositories/finance_repository.dart';

@LazySingleton(as: FinanceRepository)
class FinanceRepositoryImpl extends FinanceRepository {
  final FinanceApi _financeApi;
  FinanceRepositoryImpl(this._financeApi);

  @override
  Future<Resource<FinanceEntity>> fetchShopFinancial({
    required String shopId,
    required String startDate,
    required String endDate,
  }) async {
    final response = await request<FinanceResponse, BaseError>(
      () => _financeApi.fetchShopFinancial(
        shopId: shopId,
        startDate: startDate,
        endDate: endDate,
      ),
    );

    return response.parse<FinanceEntity>((dto) => FinanceEntity.from(dto));
  }

  @override
  Future<Resource<SettlementPeriodsEntity>> fetchSettlementPeriods({
    required String shopId,
    required int page,
    required int limit,
  }) async {
    final response = await request<SettlementPeriodsResponse, BaseError>(
      () => _financeApi.fetchSettlementPeriods(
        shopId: shopId,
        page: page,
        limit: limit,
      ),
    );

    return response.parse<SettlementPeriodsEntity>(
      (dto) => SettlementPeriodsEntity.from(dto),
    );
  }

  @override
  Future<Resource<SettlementPeriodsEntity>> fetchSettlementPeriodsWithStatus({
    required String shopId,
    required int page,
    required int limit,
    required String status,
  }) async {
    final response = await request<SettlementPeriodsResponse, BaseError>(
      () => _financeApi.fetchSettlementPeriodsWithStatus(
        shopId: shopId,
        page: page,
        limit: limit,
        status: status,
      ),
    );

    return response.parse<SettlementPeriodsEntity>(
      (dto) => SettlementPeriodsEntity.from(dto),
    );
  }
}
