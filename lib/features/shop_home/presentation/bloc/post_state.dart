import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/promotion_program_entity.dart';

part 'post_state.freezed.dart';

@freezed
abstract class PostState with _$PostState {
  const PostState._();

  const factory PostState({
    required Resource<PromotionsPageEntity> promotionsResource,
    required Resource<PromotionsPageEntity> newsResource,
    @Default([]) List<PromotionProgramEntity> listPromotions,
    @Default([]) List<PromotionProgramEntity> listNews,
  }) = _PostState;
}

extension PostStateX on PostState {
  List<PromotionProgramEntity> get homePromotions =>
      listPromotions.take(5).toList();

  List<PromotionProgramEntity> get homeNews => listNews.take(3).toList();

  bool get hasMorePromotions => promotionsResource.data?.hasMore == true;

  bool get hasMoreNews => newsResource.data?.hasMore == true;
}
