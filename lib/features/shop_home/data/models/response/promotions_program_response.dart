import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotions_program_response.freezed.dart';
part 'promotions_program_response.g.dart';

@freezed
abstract class PromotionsProgramResponse with _$PromotionsProgramResponse {
  const factory PromotionsProgramResponse({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "date") String? date,
    @JsonKey(name: "date_gmt") String? dateGmt,
    @JsonKey(name: "guid") Guid? guid,
    @JsonKey(name: "modified") String? modified,
    @JsonKey(name: "modified_gmt") String? modifiedGmt,
    @JsonKey(name: "slug") String? slug,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "link") String? link,
    @JsonKey(name: "title") Guid? title,
    @JsonKey(name: "content") Content? content,
    @JsonKey(name: "excerpt") Content? excerpt,
    @JsonKey(name: "author") int? author,
    @JsonKey(name: "featured_media") int? featuredMedia,
    @JsonKey(name: "comment_status") String? commentStatus,
    @JsonKey(name: "ping_status") String? pingStatus,
    @JsonKey(name: "template") String? template,
    @JsonKey(name: "format") String? format,
    @JsonKey(name: "meta") Meta? meta,
    @JsonKey(name: "mobile-category") List<int>? mobileCategory,
    @JsonKey(name: "class_list") List<String>? classList,
    @JsonKey(name: "acf") List<dynamic>? acf,
    @JsonKey(name: "_links") PromotionsProgramResponseLinks? links,
    @JsonKey(name: "_embedded") Embedded? embedded,
  }) = _PromotionsProgramResponse;

  factory PromotionsProgramResponse.fromJson(Map<String, dynamic> json) =>
      _$PromotionsProgramResponseFromJson(json);
}

@freezed
abstract class Content with _$Content {
  const factory Content({
    @JsonKey(name: "rendered") String? rendered,
    @JsonKey(name: "protected") bool? protected,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

@freezed
abstract class Embedded with _$Embedded {
  const factory Embedded({
    @JsonKey(name: "author") List<EmbeddedAuthor>? author,
    @JsonKey(name: "wp:featuredmedia") List<WpFeaturedmedia>? wpFeaturedmedia,
    @JsonKey(name: "wp:term") List<List<EmbeddedWpTerm>>? wpTerm,
  }) = _Embedded;

  factory Embedded.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedFromJson(json);
}

@freezed
abstract class EmbeddedAuthor with _$EmbeddedAuthor {
  const factory EmbeddedAuthor({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "url") String? url,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "link") String? link,
    @JsonKey(name: "slug") String? slug,
    @JsonKey(name: "avatar_urls") Map<String, String>? avatarUrls,
    @JsonKey(name: "acf") List<dynamic>? acf,
    @JsonKey(name: "_links") AuthorLinks? links,
  }) = _EmbeddedAuthor;

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedAuthorFromJson(json);
}

@freezed
abstract class AuthorLinks with _$AuthorLinks {
  const factory AuthorLinks({
    @JsonKey(name: "self") List<Self>? self,
    @JsonKey(name: "collection") List<About>? collection,
  }) = _AuthorLinks;

  factory AuthorLinks.fromJson(Map<String, dynamic> json) =>
      _$AuthorLinksFromJson(json);
}

@freezed
abstract class About with _$About {
  const factory About({@JsonKey(name: "href") String? href}) = _About;

  factory About.fromJson(Map<String, dynamic> json) => _$AboutFromJson(json);
}

@freezed
abstract class Self with _$Self {
  const factory Self({
    @JsonKey(name: "href") String? href,
    @JsonKey(name: "targetHints") TargetHints? targetHints,
  }) = _Self;

  factory Self.fromJson(Map<String, dynamic> json) => _$SelfFromJson(json);
}

@freezed
abstract class TargetHints with _$TargetHints {
  const factory TargetHints({@JsonKey(name: "allow") List<String>? allow}) =
      _TargetHints;

  factory TargetHints.fromJson(Map<String, dynamic> json) =>
      _$TargetHintsFromJson(json);
}

@freezed
abstract class WpFeaturedmedia with _$WpFeaturedmedia {
  const factory WpFeaturedmedia({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "date") String? date,
    @JsonKey(name: "slug") String? slug,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "link") String? link,
    @JsonKey(name: "title") Guid? title,
    @JsonKey(name: "author") int? author,
    @JsonKey(name: "featured_media") int? featuredMedia,
    @JsonKey(name: "acf") List<dynamic>? acf,
    @JsonKey(name: "caption") Guid? caption,
    @JsonKey(name: "alt_text") String? altText,
    @JsonKey(name: "media_type") String? mediaType,
    @JsonKey(name: "mime_type") String? mimeType,
    @JsonKey(name: "media_details") MediaDetails? mediaDetails,
    @JsonKey(name: "source_url") String? sourceUrl,
    @JsonKey(name: "_links") WpFeaturedmediaLinks? links,
  }) = _WpFeaturedmedia;

  factory WpFeaturedmedia.fromJson(Map<String, dynamic> json) =>
      _$WpFeaturedmediaFromJson(json);
}

@freezed
abstract class Guid with _$Guid {
  const factory Guid({@JsonKey(name: "rendered") String? rendered}) = _Guid;

  factory Guid.fromJson(Map<String, dynamic> json) => _$GuidFromJson(json);
}

@freezed
abstract class WpFeaturedmediaLinks with _$WpFeaturedmediaLinks {
  const factory WpFeaturedmediaLinks({
    @JsonKey(name: "self") List<Self>? self,
    @JsonKey(name: "collection") List<About>? collection,
    @JsonKey(name: "about") List<About>? about,
    @JsonKey(name: "author") List<ReplyElement>? author,
    @JsonKey(name: "replies") List<ReplyElement>? replies,
    @JsonKey(name: "wp:attached-to") List<WpAttachedTo>? wpAttachedTo,
    @JsonKey(name: "curies") List<Cury>? curies,
  }) = _WpFeaturedmediaLinks;

  factory WpFeaturedmediaLinks.fromJson(Map<String, dynamic> json) =>
      _$WpFeaturedmediaLinksFromJson(json);
}

@freezed
abstract class ReplyElement with _$ReplyElement {
  const factory ReplyElement({
    @JsonKey(name: "embeddable") bool? embeddable,
    @JsonKey(name: "href") String? href,
  }) = _ReplyElement;

  factory ReplyElement.fromJson(Map<String, dynamic> json) =>
      _$ReplyElementFromJson(json);
}

@freezed
abstract class Cury with _$Cury {
  const factory Cury({
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "href") String? href,
    @JsonKey(name: "templated") bool? templated,
  }) = _Cury;

  factory Cury.fromJson(Map<String, dynamic> json) => _$CuryFromJson(json);
}

@freezed
abstract class WpAttachedTo with _$WpAttachedTo {
  const factory WpAttachedTo({
    @JsonKey(name: "embeddable") bool? embeddable,
    @JsonKey(name: "post_type") String? postType,
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "href") String? href,
  }) = _WpAttachedTo;

  factory WpAttachedTo.fromJson(Map<String, dynamic> json) =>
      _$WpAttachedToFromJson(json);
}

@freezed
abstract class MediaDetails with _$MediaDetails {
  const factory MediaDetails({
    @JsonKey(name: "width") int? width,
    @JsonKey(name: "height") int? height,
    @JsonKey(name: "file") String? file,
    @JsonKey(name: "filesize") int? filesize,
    @JsonKey(name: "sizes") Sizes? sizes,
    @JsonKey(name: "image_meta") ImageMeta? imageMeta,
  }) = _MediaDetails;

  factory MediaDetails.fromJson(Map<String, dynamic> json) =>
      _$MediaDetailsFromJson(json);
}

@freezed
abstract class ImageMeta with _$ImageMeta {
  const factory ImageMeta({
    @JsonKey(name: "aperture") String? aperture,
    @JsonKey(name: "credit") String? credit,
    @JsonKey(name: "camera") String? camera,
    @JsonKey(name: "caption") String? caption,
    @JsonKey(name: "created_timestamp") String? createdTimestamp,
    @JsonKey(name: "copyright") String? copyright,
    @JsonKey(name: "focal_length") String? focalLength,
    @JsonKey(name: "iso") String? iso,
    @JsonKey(name: "shutter_speed") String? shutterSpeed,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "orientation") String? orientation,
    @JsonKey(name: "keywords") List<dynamic>? keywords,
    @JsonKey(name: "alt") String? alt,
  }) = _ImageMeta;

  factory ImageMeta.fromJson(Map<String, dynamic> json) =>
      _$ImageMetaFromJson(json);
}

@freezed
abstract class Sizes with _$Sizes {
  const factory Sizes({
    @JsonKey(name: "medium") Full? medium,
    @JsonKey(name: "large") Full? large,
    @JsonKey(name: "thumbnail") Full? thumbnail,
    @JsonKey(name: "medium_large") Full? mediumLarge,
    @JsonKey(name: "full") Full? full,
  }) = _Sizes;

  factory Sizes.fromJson(Map<String, dynamic> json) => _$SizesFromJson(json);
}

@freezed
abstract class Full with _$Full {
  const factory Full({
    @JsonKey(name: "file") String? file,
    @JsonKey(name: "width") int? width,
    @JsonKey(name: "height") int? height,
    @JsonKey(name: "mime_type") String? mimeType,
    @JsonKey(name: "source_url") String? sourceUrl,
    @JsonKey(name: "filesize") int? filesize,
  }) = _Full;

  factory Full.fromJson(Map<String, dynamic> json) => _$FullFromJson(json);
}

@freezed
abstract class EmbeddedWpTerm with _$EmbeddedWpTerm {
  const factory EmbeddedWpTerm({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "link") String? link,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "slug") String? slug,
    @JsonKey(name: "taxonomy") String? taxonomy,
    @JsonKey(name: "acf") List<dynamic>? acf,
    @JsonKey(name: "_links") WpTermLinks? links,
  }) = _EmbeddedWpTerm;

  factory EmbeddedWpTerm.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedWpTermFromJson(json);
}

@freezed
abstract class WpTermLinks with _$WpTermLinks {
  const factory WpTermLinks({
    @JsonKey(name: "self") List<Self>? self,
    @JsonKey(name: "collection") List<About>? collection,
    @JsonKey(name: "about") List<About>? about,
    @JsonKey(name: "wp:post_type") List<About>? wpPostType,
    @JsonKey(name: "curies") List<Cury>? curies,
    @JsonKey(name: "up") List<ReplyElement>? up,
  }) = _WpTermLinks;

  factory WpTermLinks.fromJson(Map<String, dynamic> json) =>
      _$WpTermLinksFromJson(json);
}

@freezed
abstract class PromotionsProgramResponseLinks
    with _$PromotionsProgramResponseLinks {
  const factory PromotionsProgramResponseLinks({
    @JsonKey(name: "self") List<Self>? self,
    @JsonKey(name: "collection") List<About>? collection,
    @JsonKey(name: "about") List<About>? about,
    @JsonKey(name: "author") List<ReplyElement>? author,
    @JsonKey(name: "replies") List<ReplyElement>? replies,
    @JsonKey(name: "version-history") List<VersionHistory>? versionHistory,
    @JsonKey(name: "predecessor-version")
    List<PredecessorVersion>? predecessorVersion,
    @JsonKey(name: "wp:featuredmedia") List<ReplyElement>? wpFeaturedmedia,
    @JsonKey(name: "wp:attachment") List<About>? wpAttachment,
    @JsonKey(name: "wp:term") List<LinksWpTerm>? wpTerm,
    @JsonKey(name: "curies") List<Cury>? curies,
  }) = _PromotionsProgramResponseLinks;

  factory PromotionsProgramResponseLinks.fromJson(Map<String, dynamic> json) =>
      _$PromotionsProgramResponseLinksFromJson(json);
}

@freezed
abstract class PredecessorVersion with _$PredecessorVersion {
  const factory PredecessorVersion({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "href") String? href,
  }) = _PredecessorVersion;

  factory PredecessorVersion.fromJson(Map<String, dynamic> json) =>
      _$PredecessorVersionFromJson(json);
}

@freezed
abstract class VersionHistory with _$VersionHistory {
  const factory VersionHistory({
    @JsonKey(name: "count") int? count,
    @JsonKey(name: "href") String? href,
  }) = _VersionHistory;

  factory VersionHistory.fromJson(Map<String, dynamic> json) =>
      _$VersionHistoryFromJson(json);
}

@freezed
abstract class LinksWpTerm with _$LinksWpTerm {
  const factory LinksWpTerm({
    @JsonKey(name: "taxonomy") String? taxonomy,
    @JsonKey(name: "embeddable") bool? embeddable,
    @JsonKey(name: "href") String? href,
  }) = _LinksWpTerm;

  factory LinksWpTerm.fromJson(Map<String, dynamic> json) =>
      _$LinksWpTermFromJson(json);
}

@freezed
abstract class Meta with _$Meta {
  const factory Meta({
    @JsonKey(name: "_acf_changed") bool? acfChanged,
    @JsonKey(name: "footnotes") String? footnotes,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}
