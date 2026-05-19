import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/error_code.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/enum.dart';

part 'finance_overview_state.freezed.dart';

@freezed
abstract class FinanceOverviewState with _$FinanceOverviewState {
  factory FinanceOverviewState({
    @Default(FinanceFilter.oneDay) FinanceFilter financeFilter,
    required DateTime startDate,
    required DateTime endDate,
    @Default(FinanceRequestSource.page) FinanceRequestSource requestSource,
    required Resource<FinanceEntity> shopFinancialData,
  }) = _FinanceOverviewState;
}

extension FinanceOverviewStateX on FinanceOverviewState {
  bool get isSecondPasswordRequired =>
      (shopFinancialData.statusCode == 401 &&
          (shopFinancialData.errorCode == ErrorCodeEnum.auth016.key ||
              shopFinancialData.errorCode == ErrorCodeEnum.auth020.key));
}
