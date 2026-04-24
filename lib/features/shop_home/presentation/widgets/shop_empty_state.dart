import 'package:oneship_customer/core/base/base_import_components.dart';

class ShopEmptyState extends StatelessWidget {
  const ShopEmptyState({super.key, required this.onCreateShopPressed});

  static const double _bottomSpacing = 96;

  final VoidCallback onCreateShopPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        AppDimensions.smallSpacing,
        AppDimensions.mediumSpacing,
        _bottomSpacing,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppDimensions.getSize(context).height * 0.72,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const _OrbitRing(size: 420),
                const _OrbitRing(size: 310),
                const _OrbitRing(size: 220),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.largeSpacing,
                    vertical: AppDimensions.largeSpacing * 1.2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 14),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.orange.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Icon(
                          Icons.storefront_outlined,
                          color: AppColors.primary,
                          size: 44,
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.neutral2,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                          ),
                          children: const [
                            TextSpan(text: 'Bạn chưa có '),
                            TextSpan(
                              text: 'cửa hàng',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            TextSpan(text: '\nhãy tạo một cửa hàng mới.'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      PrimaryText(
                        'OneShip giúp bạn quản lý đơn hàng hiệu quả hơn. Tạo shop đầu tiên để bắt đầu bán hàng và theo dõi vận hành ngay trên app.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium,
                        color: AppColors.neutral4,
                      ),
                      AppSpacing.vertical(AppDimensions.largeSpacing),
                      SizedBox(
                        width: 220,
                        child: PrimaryButton.primary(
                          label: '+  Tạo cửa hàng mới',
                          onPressed: onCreateShopPressed,
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      PrimaryText(
                        'Hướng dẫn',
                        style: AppTextStyles.labelSmall,
                        color: AppColors.neutral5,
                      ),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppDimensions.smallSpacing,
                        runSpacing: AppDimensions.smallSpacing,
                        children: const [
                          _StepBadge(index: 1, label: 'Tạo cửa hàng mới'),
                          _StepBadge(index: 2, label: 'Chờ xét duyệt'),
                          _StepBadge(
                            index: 3,
                            label: 'Bắt đầu quản lý đơn hàng',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbitRing extends StatelessWidget {
  const _OrbitRing({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.neutral8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.neutral9,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: PrimaryText(
              '$index',
              style: AppTextStyles.labelSmall,
              color: AppColors.neutral4,
            ),
          ),
          AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
          PrimaryText(
            label,
            style: AppTextStyles.labelSmall,
            color: AppColors.neutral4,
          ),
        ],
      ),
    );
  }
}
