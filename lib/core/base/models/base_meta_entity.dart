import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';

part 'base_meta_entity.freezed.dart';

@freezed
abstract class BaseMetaEntity with _$BaseMetaEntity {
  const factory BaseMetaEntity({
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    bool? hasPrevious,
    bool? hasNext,
  }) = _BaseMetaEntity;

  factory BaseMetaEntity.from(BaseMetaResponse dto) => BaseMetaEntity(
    page: dto.page,
    limit: dto.limit,
    total: dto.total,
    totalPages: dto.totalPages,
    hasPrevious: dto.hasPrevious,
    hasNext: dto.hasNext,
  );
}
