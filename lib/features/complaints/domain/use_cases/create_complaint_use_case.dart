import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:oneship_customer/features/complaints/domain/repositories/complaint_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateComplaintUseCase {
  final ComplaintRepository _repository;

  CreateComplaintUseCase(this._repository);

  Future<Resource<ComplaintEntity>> call({
    required String category,
    required String priority,
    required String subject,
    required String description,
    required String referenceType,
    required String referenceId,
    required String shopId,
  }) {
    return _repository.createComplaint(
      category: category,
      priority: priority,
      subject: subject,
      description: description,
      referenceType: referenceType,
      referenceId: referenceId,
      shopId: shopId,
    );
  }
}
