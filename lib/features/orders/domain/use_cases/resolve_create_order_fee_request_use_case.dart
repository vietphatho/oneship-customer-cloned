import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';

@lazySingleton
class ResolveCreateOrderFeeRequestUseCase {
  const ResolveCreateOrderFeeRequestUseCase();

  CalculateDeliveryFeeRequest? call({
    required CreateOrderRequestEntity draftRequest,
    required String? shopId,
    required double? routeDistance,
    required List<String> selectedSurchargeCodes,
    required Map<String, int> selectedSurchargeValues,
    required bool hasInvalidSelectedSurcharges,
  }) {
    final distance = routeDistance ?? draftRequest.router?.distance;
    final serviceCode = draftRequest.serviceConfig?.serviceCode;
    final weight = draftRequest.detail?.weight?.toInt();
    final provinceCode = draftRequest.province?.code;
    final wardCode = draftRequest.ward?.code;

    if (shopId == null || shopId.isEmpty) return null;
    if (distance == null || distance <= 0) return null;
    if (serviceCode == null || serviceCode.isEmpty) return null;
    if (weight == null || weight <= 0) return null;
    if (hasInvalidSelectedSurcharges) return null;
    if (provinceCode == null) return null;
    if (wardCode == null) return null;

    return CalculateDeliveryFeeRequest(
      shopId: shopId,
      distance: distance,
      serviceCode: serviceCode,
      weight: weight,
      provinceCode: provinceCode,
      wardCode: wardCode,
      surcharges: selectedSurchargeCodes,
      surchargesValues: selectedSurchargeValues,
    );
  }
}
