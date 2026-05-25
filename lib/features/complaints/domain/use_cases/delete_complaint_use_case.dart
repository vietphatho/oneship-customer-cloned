import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/complaints/domain/repositories/complaint_repository.dart';

@lazySingleton
class DeleteComplaintUseCase {
  final ComplaintRepository _repository;

  DeleteComplaintUseCase(this._repository);

  Future<Resource<bool>> call(String id) {
    return _repository.deleteComplaint(id);
  }
}
