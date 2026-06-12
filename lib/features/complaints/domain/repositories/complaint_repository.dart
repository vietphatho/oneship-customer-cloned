import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';

abstract class ComplaintRepository {
  Future<Resource<List<ComplaintEntity>>> getComplaints({
    required String category,
    required String shopId,
    String? status,
    int? page,
    int? limit,
  });

  Future<Resource<ComplaintEntity>> createComplaint({
    required String category,
    required String priority,
    required String subject,
    required String description,
    required String referenceType,
    required String referenceId,
    required String shopId,
  });

  Future<Resource<bool>> deleteComplaint(String id);

  Future<Resource<dynamic>> getComplaintSummary({required String shopId});

  Future<Resource<dynamic>> getComplaintsTotal({
    required String category,
    required String shopId,
    String? status,
  });

  Future<Resource<dynamic>> getAssignedPackagesTotal({required String shopId});

  Future<Resource<dynamic>> getActivePackagesTotal({required String shopId});
}
