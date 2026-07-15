import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/data/datasources/finance_api.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/finance_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/period_detail_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/settlement_config_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/settlement_payouts_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/settlement_periods_response.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_payouts_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/repositories/finance_repository.dart';

@LazySingleton(as: VendorFinanceRepository)
class VendorFinanceRepositoryImpl extends VendorFinanceRepository {
  final VendorFinanceApi _vendorFinanceApi;
  VendorFinanceRepositoryImpl(this._vendorFinanceApi);

  @override
  Future<Resource<VendorFinanceEntity>> fetchVendorFinancialSummary({
    required String userId,
    required String startDate,
    required String endDate,
  }) async {
    final response = await request<VendorFinanceResponse, BaseError>(
      () => _vendorFinanceApi.fetchVendorFinancialSummary(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      ),
    );

    return response.parse<VendorFinanceEntity>(
      (dto) => VendorFinanceEntity.from(dto),
    );
  }

  @override
  Future<Resource<SettlementPeriodsEntity>> fetchSettlementPeriods({
    required String userId,
    int? page,
    int? limit,
    String? status,
  }) async {
    final response = await request<SettlementPeriodsResponse, BaseError>(
      () => _vendorFinanceApi.fetchSettlementPeriods(
        userId: userId,
        page: page,
        limit: limit,
        status: status,
      ),
    );

    return response.parse<SettlementPeriodsEntity>(
      (dto) => SettlementPeriodsEntity.from(dto),
    );
  }

  @override
  Future<Resource<PeriodDetailEntity>> fetchPeriodsDetail({
    required String userId,
    required String id,
  }) async {
    final response = await request<PeriodDetailResponse, BaseError>(
      () => _vendorFinanceApi.fetchPeriodsDetail(id: id, userId: userId),
    );

    return response.parse<PeriodDetailEntity>(
      (dto) => PeriodDetailEntity.from(dto),
    );
  }

  @override
  Future<Resource<SettlementConfigEntity>> fetchSettlementConfig({
    required String userId,
  }) async {
    final response = await request<SettlementConfigResponse, BaseError>(
      () => _vendorFinanceApi.fetchSettlementConfig(userId: userId),
    );

    return response.parse<SettlementConfigEntity>(
      (dto) => SettlementConfigEntity.from(dto),
    );
  }

  @override
  Future<Resource<SettlementPayoutsEntity>> fetchSettlementPayouts({
    required String userId,
    int? page,
    int? limit,
  }) async {
    final response = await request<SettlementPayoutsResponse, BaseError>(
      () => _vendorFinanceApi.fetchSettlementPayouts(
        userId: userId,
        page: page,
        limit: limit,
      ),
    );

    return response.parse<SettlementPayoutsEntity>(
      (dto) => SettlementPayoutsEntity.from(dto),
    );
  }
}
