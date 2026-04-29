import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';

class ShopEmptyState extends StatelessWidget {
  const ShopEmptyState({super.key, required this.onCreateShopPressed});

  static const double _bottomSpacing = 96;

  final VoidCallback onCreateShopPressed;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.getSize(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        AppDimensions.smallSpacing,
        AppDimensions.mediumSpacing,
        _bottomSpacing,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: size.height * 0.78),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ImagePath.logo, width: size.width * 0.48),
                AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                PrimaryText(
                  'Bạn chưa có cửa hàng?\nHãy tạo một cửa hàng mới.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineSmall.copyWith(
                    height: 1.45,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.vertical(AppDimensions.xLargeSpacing),
                PrimaryText(
                  'OneShip giúp bạn quản lý đơn hàng hiệu quả hơn.\nHãy tạo cửa hàng đầu tiên của bạn để bắt đầu hành trình bán hàng suôn sẻ và thành công với OneShip!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    height: 1.35,
                    color: Colors.black,
                  ),
                ),
                AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                SizedBox(
                  width: size.width * 0.48,
                  height: size.width * 0.48,
                  child: Image.asset(
                    ImagePath.shopOnboarding,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.storefront_outlined,
                          size: 120,
                          color: AppColors.primary,
                        ),
                  ),
                ),
                AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                PrimaryButton(
                  label: 'Tạo cửa hàng mới',
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  onPressed: onCreateShopPressed,
                  child: Container(
                    height: AppDimensions.largeHeightButton,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppDimensions.smallBorderRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 34),
                        AppSpacing.horizontal(AppDimensions.smallSpacing),
                        PrimaryText(
                          'Tạo cửa hàng mới',
                          style: AppTextStyles.titleMedium,
                          color: Colors.white,
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppDimensions.largeSpacing,
                  runSpacing: AppDimensions.mediumSpacing,
                  children: const [
                    _StepBadge(index: 1, label: 'Tạo cửa hàng mới'),
                    _StepBadge(index: 2, label: 'Chờ xét duyệt'),
                    _StepBadge(index: 3, label: 'Bắt đầu quản lý đơn hàng'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.index, required this.label});

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.smallBorderRadius,
        border: Border.all(color: AppColors.neutral7),
      ),
      child: PrimaryText(
        '$index.  $label',
        style: AppTextStyles.bodyLarge.copyWith(color: Colors.black),
      ),
    );
  }
}
