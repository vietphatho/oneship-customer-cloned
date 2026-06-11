import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/repositories/complaint_repository.dart';

@lazySingleton
class GetComplaintSummaryUseCase {
  final ComplaintRepository _repository;

  GetComplaintSummaryUseCase(this._repository);

  Future<Resource<dynamic>> call({required String shopId}) async {
    return await _repository.getComplaintSummary(shopId: shopId);
  }
}
