import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/promotions_program_response.dart';

part 'promotion_program_entity.freezed.dart';

@freezed
abstract class PromotionProgramEntity with _$PromotionProgramEntity {
  const PromotionProgramEntity._();

  const factory PromotionProgramEntity({
    required int id,
    required String title,
    String? publishedDate,
    String? thumbnailUrl,
    String? link,
  }) = _PromotionProgramEntity;

  factory PromotionProgramEntity.from(PromotionsProgramResponse response) {
    final featuredMedia = response.embedded?.wpFeaturedmedia;
    return PromotionProgramEntity(
      id: response.id ?? 0,
      title: _cleanText(response.title?.rendered),
      publishedDate: _formatPublishedDate(response.date),
      thumbnailUrl: featuredMedia == null || featuredMedia.isEmpty
          ? null
          : featuredMedia.first.mediaDetails?.sizes?.medium?.sourceUrl,
      link: response.link,
    );
  }
}

String? _formatPublishedDate(String? value) {
  final date = DateTime.tryParse(value ?? '');
  if (date == null) return value;

  return DateFormat(Constants.defaultDateFormat).format(date);
}

@freezed
abstract class PromotionsPageEntity with _$PromotionsPageEntity {
  const factory PromotionsPageEntity({
    required List<PromotionProgramEntity> items,
    required int page,
    required bool hasMore,
  }) = _PromotionsPageEntity;
}

String _cleanText(String? value) {
  final withoutTags = (value ?? '').replaceAll(RegExp(r'<[^>]*>'), '').trim();
  return withoutTags
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#8211;', '-')
      .replaceAll('&#8217;', "'")
      .replaceAll('&nbsp;', ' ');
}
