import 'package:freezed_annotation/freezed_annotation.dart';

part 'complaint_event.freezed.dart';

@freezed
abstract class ComplaintEvent with _$ComplaintEvent {
  const factory ComplaintEvent.started({required String category}) = ComplaintStarted;
  const factory ComplaintEvent.complaintDeleted({required String id}) = ComplaintDeleted;
}
