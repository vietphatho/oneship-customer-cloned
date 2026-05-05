import 'package:oneship_customer/core/base/base_import_components.dart';

class OrdersHistoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const OrdersHistoryAppBar({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      leading: Center(
        child: _OrdersHistoryCircleIconButton(
          icon: Icons.chevron_left_rounded,
          onTap: onBack,
        ),
      ),
      title: Text(
        "Đơn hàng đã xử lý",
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Center(
          child: _OrdersHistoryCircleIconButton(
            icon: Icons.chevron_right_rounded,
            onTap: onNext,
          ),
        ),
        AppSpacing.horizontal(AppDimensions.mediumSpacing),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _OrdersHistoryCircleIconButton extends StatelessWidget {
  const _OrdersHistoryCircleIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.xLargeBorderRadius,
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
