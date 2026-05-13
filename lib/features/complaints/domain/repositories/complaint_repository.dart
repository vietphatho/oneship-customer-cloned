import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';

abstract class ComplaintRepository {
  Future<Resource<List<ComplaintEntity>>> getComplaints({
    required String category,
    String? shopId,
  });

  Future<Resource<ComplaintEntity>> createComplaint({
    required String category,
    required String priority,
    required String subject,
    required String description,
    required String referenceType,
    required String referenceId,
    String? shopId,
  });

  Future<Resource<bool>> deleteComplaint(String id);
}
