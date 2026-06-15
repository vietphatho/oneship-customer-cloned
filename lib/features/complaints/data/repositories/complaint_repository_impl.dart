import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/data/datasources/complaint_api.dart';
import 'package:oneship_customer/features/complaints/data/models/complaint_model.dart';
import 'package:oneship_customer/features/complaints/data/models/response/complaint_list_response.dart';
import 'package:oneship_customer/features/complaints/data/models/request/create_complaint_request.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:oneship_customer/features/complaints/domain/repositories/complaint_repository.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';

@LazySingleton(as: ComplaintRepository)
class ComplaintRepositoryImpl extends BaseRepository implements ComplaintRepository {
  final ComplaintApi _api;

  ComplaintRepositoryImpl(this._api);

  @override
  Future<Resource<List<ComplaintEntity>>> getComplaints({
    required String category,
    required String shopId,
    String? status,
    int? page,
    int? limit,
  }) async {
    final response = await request<ComplaintListResponse, BaseError>(
      () => _api.getComplaints(category: category, shopId: shopId, status: status, page: page, limit: limit),
    );

    return response.parse((listResponse) => (listResponse.items ?? []).map((e) => e.toEntity()).toList());
  }

  @override
  Future<Resource<ComplaintEntity>> createComplaint({
    required String category,
    required String priority,
    required String subject,
    required String description,
    required String referenceType,
    required String referenceId,
    String? shopId,
  }) async {
    final requestBody = CreateComplaintRequest(
      category: category,
      priority: priority,
      subject: subject,
      description: description,
      referenceType: referenceType,
      referenceId: referenceId,
      shopId: shopId,
    );

    final response = await request<ComplaintModel, BaseError>(
      () => _api.createComplaint(body: requestBody),
    );

    return response.parse((model) => model.toEntity());
  }

  @override
  Future<Resource<bool>> deleteComplaint(String id) {
    return request<bool, BaseError>(() => _api.deleteComplaint(id));
  }

  @override
  Future<Resource<dynamic>> getComplaintSummary({required String shopId}) {
    return request<dynamic, BaseError>(
      () => _api.getComplaintSummary(shopId: shopId),
    );
  }

  @override
  Future<Resource<dynamic>> getComplaintsTotal({
    required String category,
    required String shopId,
    String? status,
  }) async {
    final response = await request<ComplaintListResponse, BaseError>(
      () => _api.getComplaints(category: category, shopId: shopId, status: status, limit: 1, page: 1),
    );
    return response.parse((res) => res.meta?.total ?? 0);
  }

  @override
  Future<Resource<dynamic>> getAssignedPackagesTotal({required String shopId}) async {
    final response = await request<PackagesListResponse, BaseError>(
      () => _api.getAssignedPackages(shopId: shopId, status: 'assigned', limit: 1),
    );
    return response.parse((res) => res.meta?.total ?? 0);
  }

  @override
  Future<Resource<dynamic>> getActivePackagesTotal({required String shopId}) async {
    final response = await request<PackagesListResponse, BaseError>(
      () => _api.getActivePackages(shopId: shopId, limit: 10, page: 1),
    );
    return response.parse((res) => res.meta?.total ?? 0);
  }
}
