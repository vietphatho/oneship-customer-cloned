import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';

part 'complaint_state.freezed.dart';

@freezed
abstract class ComplaintState with _$ComplaintState {
  const factory ComplaintState({
    required Resource<List<ComplaintEntity>> complaintsResource,
    required String selectedCategory,
    required Resource<bool> deleteResource,
    String? shopId,
  }) = _ComplaintState;

  factory ComplaintState.initial() => ComplaintState(
        complaintsResource: Resource.loading(),
        selectedCategory: 'complaints.order_issues',
        deleteResource: Resource.loading(),
      );
}
