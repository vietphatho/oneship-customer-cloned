import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/data/datasources/finance_api.dart';
import 'package:oneship_customer/features/finance/data/models/response/finance_response.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
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
}
