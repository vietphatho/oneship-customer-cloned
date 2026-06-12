import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';

class CustomerCreditLimitDialog extends StatelessWidget {
  const CustomerCreditLimitDialog({super.key, this.onViewDetail});

  final VoidCallback? onViewDetail;

  static Future<dynamic> show(BuildContext context) {
    return PrimaryDialog.showDefaultDialog(
      context,
      child: const CustomerCreditLimitDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.smallSpacing,
        ),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 680),
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.smallSpacing,
                  AppDimensions.smallSpacing,
                  AppDimensions.smallSpacing,
                  AppDimensions.smallSpacing,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 242, 205),
                  borderRadius: AppDimensions.xLargeBorderRadius,
                  border: Border.all(
                    color: AppColors.primary,
                    width: AppDimensions.mediumBorderStroke,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // const _CreditLimitIllustration(),
                    Image.asset(
                      ImagePath.moneyBag,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    AppSpacing.horizontal(AppDimensions.mediumSpacing),
                    const Expanded(child: _CreditLimitContent()),
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    // _DetailButton(onViewDetail: onViewDetail),
                  ],
                ),
              ),
              Positioned(
                top: AppDimensions.smallSpacing,
                right: AppDimensions.smallSpacing,
                child: PrimaryAnimatedPressableWidget(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.neutral5,
                    size: AppDimensions.mediumIconSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreditLimitIllustration extends StatelessWidget {
  const _CreditLimitIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 104,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 10,
            bottom: 8,
            child: Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: Color(0xFF8BC33F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.attach_money_rounded,
                color: Color(0xFFFFF2C6),
                size: 42,
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 14,
            child: Container(
              width: 48,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF78A92F),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 16,
            child: Container(
              width: 42,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.successForeground,
                borderRadius: AppDimensions.mediumBorderRadius,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: AppDimensions.largeIconSize,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 8,
            child: SvgPicture.asset(
              ImagePath.iconMoney1,
              width: AppDimensions.xLargeIconSize,
              height: AppDimensions.xLargeIconSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditLimitContent extends StatelessWidget {
  const _CreditLimitContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PrimaryText(
          'Chúc mừng! 🎉',
          style: AppTextStyles.titleXLarge,
          color: AppColors.neutral2,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
        const PrimaryText(
          'Bạn đã đủ điều kiện để được cấp\nhạn mức tín dụng lên đến',
          style: AppTextStyles.bodyXSmall,
          color: AppColors.neutral2,
        ),
        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
        PrimaryText(
          '500.000.000đ',
          style: AppTextStyles.titleXLarge,
          color: AppColors.primary,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
        const PrimaryText(
          'Xem ngay để biết thêm chi tiết.',
          style: AppTextStyles.bodyXSmall,
          color: AppColors.info,
          decoration: TextDecoration.underline,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
      ],
    );
  }
}

class _DetailButton extends StatelessWidget {
  const _DetailButton({this.onViewDetail});

  final VoidCallback? onViewDetail;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: () {
        Navigator.pop(context);
        onViewDetail?.call();
      },
      child: const SizedBox(
        width: AppDimensions.xxxLargeSpacing,
        height: AppDimensions.xxxLargeSpacing,
        child: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.neutral2,
          size: AppDimensions.xxxLargeSpacing,
        ),
      ),
    );
  }
}
