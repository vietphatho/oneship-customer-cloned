import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';

class ShopHomePromotionBanner extends StatefulWidget {
  const ShopHomePromotionBanner({super.key});

  @override
  State<ShopHomePromotionBanner> createState() =>
      _ShopHomePromotionBannerState();
}

class _ShopHomePromotionBannerState extends State<ShopHomePromotionBanner> {
  static const int _bannerCount = 2;

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1909 / 824,
      child: ClipRRect(
        borderRadius: AppDimensions.largeBorderRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: CarouselSlider.builder(
                itemCount: _bannerCount,
                itemBuilder: (_, __, ___) {
                  return Image.asset(
                    ImagePath.shopHomePromotionOzoShipNoCtaGenerated,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 450),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: false,
                  onPageChanged: (page, _) {
                    setState(() => _currentPage = page);
                  },
                ),
              ),
            ),
            Positioned(
              left: AppDimensions.mediumSpacing,
              bottom: AppDimensions.mediumSpacing,
              child: PrimaryActionButton(
                label: 'shop_home.create_order_now'.tr(),
                type: PrimaryActionButtonType.outlined,
                height: 30,
                padding: AppDimensions.smallPaddingHorizontal,
                backgroundColor: AppColors.background,
                trailingIcon: const Icon(Icons.arrow_forward_rounded),
                onPressed: () => context.push(RouteName.createOrderPage),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppDimensions.xSmallSpacing,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _bannerCount,
                  (index) => _BannerIndicator(
                    isActive: index == _currentPage,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerIndicator extends StatelessWidget {
  const _BannerIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 16 : 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.background : Colors.white54,
        borderRadius: AppDimensions.smallBorderRadius,
      ),
    );
  }
}

class ShopHomeOfferSection extends StatelessWidget {
  const ShopHomeOfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      title: 'shop_home.offers'.tr(),
      child: Row(
        children: [
          Expanded(
            child: _OfferCard(
              title: 'shop_home.shipping_offer'.tr(),
              subtitle: 'shop_home.discount_up_to'.tr(),
              condition: 'shop_home.conditions_apply'.tr(),
              value: '20%',
              color: const Color(0xFFEAF5FF),
              valueColor: AppColors.secondary,
              image: ImagePath.shopHomeOfferShippingGenerated,
            ),
          ),
          const SizedBox(width: AppDimensions.xSmallSpacing),
          Expanded(
            child: _OfferCard(
              title: 'shop_home.surcharge_offer'.tr(),
              subtitle: 'shop_home.only_from'.tr(),
              condition: 'shop_home.conditions_apply'.tr(),
              value: '5K',
              color: AppColors.warningBackground,
              valueColor: AppColors.warningForeground,
              image: ImagePath.shopHomeOfferSurchargeGenerated,
            ),
          ),
          const SizedBox(width: AppDimensions.xSmallSpacing),
          Expanded(
            child: _OfferCard(
              title: 'shop_home.freeship_offer'.tr(),
              subtitle: 'shop_home.orders_from'.tr(),
              condition: 'shop_home.conditions_apply'.tr(),
              value: '500K',
              color: AppColors.successBackground,
              valueColor: AppColors.successForeground,
              image: ImagePath.shopHomeOfferFreeshipGenerated,
            ),
          ),
        ],
      ),
    );
  }
}

class ShopHomeNewsSection extends StatelessWidget {
  const ShopHomeNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      title: 'shop_home.news'.tr(),
      child: Row(
        children: [
          Expanded(
            child: _NewsCard(
              title: 'shop_home.partner_news'.tr(),
              description: 'shop_home.partner_news_description'.tr(),
              date: '12/05/2025',
              image: ImagePath.shopHomeNewsPartnerGenerated,
            ),
          ),
          const SizedBox(width: AppDimensions.xSmallSpacing),
          Expanded(
            child: _NewsCard(
              title: 'shop_home.policy_news'.tr(),
              description: 'shop_home.policy_news_description'.tr(),
              date: '10/05/2025',
              image: ImagePath.shopHomeNewsPolicyGenerated,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  const _HomeSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PrimaryText(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontSize: 14,
                  height: 1.1,
                ),
              ),
            ),
            PrimaryText(
              'shop_home.view_all'.tr(),
              style: AppTextStyles.labelXSmall.copyWith(
                fontSize: 14,
                height: 1,
              ),
              color: AppColors.primary,
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: AppDimensions.xSmallIconSize,
              color: AppColors.primary,
            ),
          ],
        ),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        child,
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.title,
    required this.subtitle,
    required this.condition,
    required this.value,
    required this.color,
    required this.valueColor,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String condition;
  final String value;
  final Color color;
  final Color valueColor;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppDimensions.largeBorderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: 3,
            bottom: 5,
            child: Image.asset(
              image,
              width: 64,
              height: 58,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 8, 6, 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                PrimaryText(
                  title,
                  maxLine: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelXSmall.copyWith(
                    fontSize: 14,
                    height: 1.05,
                  ),
                  color: valueColor,
                ),
                AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
                PrimaryText(
                  subtitle,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    height: 1.05,
                  ),
                  color: valueColor,
                ),
                const Spacer(),
                SizedBox(
                  width: 66,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: PrimaryText(
                      value,
                      style: AppTextStyles.titleXXLarge.copyWith(
                        fontSize: 25,
                        height: 1,
                      ),
                      color: valueColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: PrimaryText(
                    condition,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 7,
                      height: 1.05,
                    ),
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.title,
    required this.description,
    required this.date,
    required this.image,
  });

  final String title;
  final String description;
  final String date;
  final String image;

  @override
  Widget build(BuildContext context) {
    return PrimaryPanel(
      height: 220,
      padding: const EdgeInsets.all(8),
      borderRadius: AppDimensions.largeBorderRadius,
      borderColor: Colors.transparent,
      backgroundColor: AppColors.backgroundColor,
      boxShadow: [PrimaryBoxShadows.defaultShadow],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppDimensions.smallBorderRadius,
            child: SizedBox(
              height: 108,
              width: double.infinity,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          PrimaryText(
            title,
            maxLine: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelXSmall.copyWith(
              fontSize: 14,
              height: 1.12,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
          PrimaryText(
            description,
            maxLine: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12,
              height: 1.1,
            ),
            color: AppColors.neutral5,
          ),
          const Spacer(),
          PrimaryText(
            date,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              height: 1,
            ),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
