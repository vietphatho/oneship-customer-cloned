import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';

@lazySingleton
class ValidateCreateOrderInfoUseCase {
  String? validateConfirmInfoStep({
    required CreateOrderRequestEntity request,
    required bool acceptTerms,
    bool isHospitalOrder = false,
  }) {
    if (isHospitalOrder && request.hospitalMetadata?.hasRequiredInfo != true) {
      return "please_enter_hospital_required_info";
    }
    if (!isHospitalOrder && (request.detail?.commodityType.isEmpty ?? true)) {
      return "please_select_commodity_type";
    }
    if (!isHospitalOrder && (request.detail?.handlingType.isEmpty ?? true)) {
      return "please_select_handling_type";
    }
    if (!acceptTerms) {
      return "please_accept_terms";
    }
    return null;
  }
}
