import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/orders/data/models/request/validate_ord_at_hub_request.dart';
import 'package:oneship_shop/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class ValidateOrdAtHubUseCase {
  final OrdersRepository _repository;

  ValidateOrdAtHubUseCase(this._repository);

  Future<Resource> call({required String hubId, required String ordId}) {
    ValidateOrdAtHubRequest body = ValidateOrdAtHubRequest(
      orderId: ordId,
      nextAction: "retry",
    );
    return _repository.validateOrdAtHub(hubId: hubId, body: body);
  }
}
