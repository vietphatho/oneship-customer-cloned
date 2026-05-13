import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_complaint_event.freezed.dart';

@freezed
abstract class CreateComplaintEvent with _$CreateComplaintEvent {
  const factory CreateComplaintEvent.started() = CreateComplaintStarted;
  const factory CreateComplaintEvent.submitted({
    required String category,
    required String priority,
    required String subject,
    required String description,
    required String referenceType,
    required String referenceId,
  }) = CreateComplaintSubmitted;
}
