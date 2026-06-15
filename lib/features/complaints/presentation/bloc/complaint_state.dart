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
    required Resource<dynamic> summaryResource,
    String? shopId,
    String? selectedStatus,
    @Default(1) int page,
    @Default(true) bool canLoadMore,
  }) = _ComplaintState;

  factory ComplaintState.initial() => ComplaintState(
        complaintsResource: Resource.loading(),
        selectedCategory: 'order_issue',
        deleteResource: Resource.loading(),
        summaryResource: Resource.loading(),
      );
}
