import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/error_code.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';

part 'finance_overview_state.freezed.dart';

@freezed
abstract class VendorFinanceOverviewState with _$VendorFinanceOverviewState {
  factory VendorFinanceOverviewState({
    @Default(VendorFinanceFilter.oneDay) VendorFinanceFilter financeFilter,
    required DateTime startDate,
    required DateTime endDate,
    @Default(VendorFinanceRequestSource.page)
    VendorFinanceRequestSource requestSource,
    required Resource<VendorFinanceEntity> vendorFinancialData,
  }) = _VendorFinanceOverviewState;
}

extension VendorFinanceOverviewStateX on VendorFinanceOverviewState {
  bool get isSecondPasswordRequired =>
      vendorFinancialData.statusCode == 401 &&
      (vendorFinancialData.errorCode == ErrorCodeEnum.auth016.key ||
          vendorFinancialData.errorCode == ErrorCodeEnum.auth020.key);
}
