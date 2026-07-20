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
                itemBuilder: (context, index, realIndex) {
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
                  (index) => _BannerIndicator(isActive: index == _currentPage),
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
