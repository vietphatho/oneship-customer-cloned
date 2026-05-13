import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:oneship_customer/features/complaints/domain/repositories/complaint_repository.dart';

@lazySingleton
class GetComplaintsUseCase {
  final ComplaintRepository _repository;

  GetComplaintsUseCase(this._repository);

  Future<Resource<List<ComplaintEntity>>> call({
    required String category,
    String? shopId,
  }) {
    return _repository.getComplaints(category: category, shopId: shopId);
  }
}
