import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/complaints/domain/entities/complaint_entity.dart';

part 'create_complaint_state.freezed.dart';

@freezed
abstract class CreateComplaintState with _$CreateComplaintState {
  const factory CreateComplaintState({
    required Resource<ComplaintEntity> createResource,
  }) = _CreateComplaintState;

  factory CreateComplaintState.initial() => CreateComplaintState(
        createResource: Resource.loading(),
      );
}
