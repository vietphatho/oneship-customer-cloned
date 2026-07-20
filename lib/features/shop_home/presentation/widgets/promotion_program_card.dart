import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/promotion_program_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionProgramCard extends StatelessWidget {
  const PromotionProgramCard({super.key, required this.promotion, this.width});

  static const double homeListHeight = 180;

  final PromotionProgramEntity promotion;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ShopHomeArticleCard(
      article: promotion,
      width: width,
      showDate: true,
    );
  }
}

class ShopHomeArticleCard extends StatelessWidget {
  const ShopHomeArticleCard({
    super.key,
    required this.article,
    this.width,
    this.showDate = false,
    this.layout = ShopHomeArticleCardLayout.vertical,
  });

  final PromotionProgramEntity article;
  final double? width;
  final bool showDate;
  final ShopHomeArticleCardLayout layout;

  @override
  Widget build(BuildContext context) {
    return PrimaryPanel(
      width: width,
      padding: AppDimensions.xSmallPaddingAll,
      borderRadius: AppDimensions.largeBorderRadius,
      borderColor: Colors.transparent,
      backgroundColor: AppColors.backgroundColor,
      boxShadow: [PrimaryBoxShadows.defaultShadow],
      onTap: article.link == null ? null : _openArticle,
      child: layout == ShopHomeArticleCardLayout.horizontal
          ? _HorizontalArticleContent(article: article, showDate: showDate)
          : _VerticalArticleContent(article: article, showDate: showDate),
    );
  }

  Future<void> _openArticle() async {
    final link = article.link;
    if (link == null || link.isEmpty) return;

    await launchUrl(Uri.parse(link), mode: LaunchMode.inAppBrowserView);
  }
}

enum ShopHomeArticleCardLayout { vertical, horizontal }

class _VerticalArticleContent extends StatelessWidget {
  const _VerticalArticleContent({
    required this.article,
    required this.showDate,
  });

  final PromotionProgramEntity article;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ArticleThumbnail(imageUrl: article.thumbnailUrl),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        _ArticleTitle(article: article, maxLine: showDate ? 2 : 3),
        if (showDate && article.publishedDate?.isNotEmpty == true) ...[
          AppSpacing.vertical(AppDimensions.xxSmallSpacing),
          _ArticleDate(article.publishedDate),
        ],
      ],
    );
  }
}

class _HorizontalArticleContent extends StatelessWidget {
  const _HorizontalArticleContent({
    required this.article,
    required this.showDate,
  });

  final PromotionProgramEntity article;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: _ArticleThumbnail(
              imageUrl: article.thumbnailUrl,
              height: 88,
            ),
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ArticleTitle(article: article, maxLine: 2),
                if (showDate && article.publishedDate?.isNotEmpty == true) ...[
                  AppSpacing.vertical(AppDimensions.xSmallSpacing),
                  _ArticleDate(article.publishedDate),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleThumbnail extends StatelessWidget {
  const _ArticleThumbnail({required this.imageUrl, this.height = 108});

  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return ClipRRect(
      borderRadius: AppDimensions.smallBorderRadius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: url == null || url.isEmpty
            ? const _ArticleImagePlaceholder()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const _ArticleImagePlaceholder(),
              ),
      ),
    );
  }
}

class _ArticleTitle extends StatelessWidget {
  const _ArticleTitle({required this.article, required this.maxLine});

  final PromotionProgramEntity article;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return PrimaryText(
      article.title.isEmpty
          ? 'shop_home.untitled_promotion'.tr()
          : article.title,
      maxLine: maxLine,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.labelSmall,
      color: AppColors.neutral2,
    );
  }
}

class _ArticleDate extends StatelessWidget {
  const _ArticleDate(this.date);

  final String? date;

  @override
  Widget build(BuildContext context) {
    return PrimaryText(
      date,
      maxLine: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.bodySmall.copyWith(fontSize: 10, height: 1),
      color: AppColors.neutral5,
    );
  }
}

class _ArticleImagePlaceholder extends StatelessWidget {
  const _ArticleImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.neutral9,
      child: Icon(
        Icons.local_offer_outlined,
        size: AppDimensions.largeIconSize,
        color: AppColors.neutral6,
      ),
    );
  }
}
