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

@LazySingleton(as: ComplaintRepository)
class ComplaintRepositoryImpl extends BaseRepository implements ComplaintRepository {
  final ComplaintApi _api;

  ComplaintRepositoryImpl(this._api);

  @override
  Future<Resource<List<ComplaintEntity>>> getComplaints({
    required String category,
    String? shopId,
  }) async {
    final response = await request<ComplaintListResponse, BaseError>(
      () => _api.getComplaints(category: category, shopId: shopId),
    );

    return response.parse((listResponse) => (listResponse.data ?? listResponse.items ?? []).map((e) => e.toEntity()).toList());
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
}
