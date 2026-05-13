import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';

part 'complaint_model.freezed.dart';
part 'complaint_model.g.dart';

@freezed
abstract class ComplaintModel with _$ComplaintModel {
  const factory ComplaintModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "ticketNumber") String? ticketNumber,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "category") String? category,
    @JsonKey(name: "priority") String? priority,
    @JsonKey(name: "subject") String? subject,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "referenceType") String? referenceType,
    @JsonKey(name: "referenceId") String? referenceId,
    @JsonKey(name: "status") String? status,
  }) = ComplaintModelData;

  factory ComplaintModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintModelFromJson(json);
}

extension ComplaintModelExt on ComplaintModel {
  ComplaintEntity toEntity() {
    return ComplaintEntity(
      id: id ?? '',
      code: ticketNumber ?? '',
      createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
      category: category ?? '',
      priority: priority ?? "",
      title: subject ?? "",
      description: description ?? "",
      referenceType: referenceType ?? "",
      referenceCode: referenceId ?? '',
      status: status ?? '',
    );
  }
}
