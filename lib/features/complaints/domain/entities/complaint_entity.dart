import 'package:freezed_annotation/freezed_annotation.dart';

part 'complaint_entity.freezed.dart';

@freezed
abstract class ComplaintEntity with _$ComplaintEntity {
  const factory ComplaintEntity({
    required String id,
    required String code,
    required DateTime createdAt,
    required String category,
    required String priority,
    required String title,
    required String description,
    required String referenceType,
    required String referenceCode,
    required String status,
  }) = ComplaintEntityData;
}
