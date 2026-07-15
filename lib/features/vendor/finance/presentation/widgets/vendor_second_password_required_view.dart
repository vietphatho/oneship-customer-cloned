import 'package:oneship_customer/core/base/base_import_components.dart';

class VendorSecondPasswordRequiredView extends StatelessWidget {
  const VendorSecondPasswordRequiredView({
    super.key,
    required this.onCreatePressed,
  });

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppDimensions.mediumPaddingAll,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/ic_colorful_security.svg',
                width: AppDimensions.displayIconSize,
              ),
              AppSpacing.vertical(AppDimensions.largeSpacing),
              PrimaryText(
                'vendor_finance.second_password_required.title'.tr(),
                style: AppTextStyles.titleXXLarge,
                textAlign: TextAlign.center,
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              PrimaryText(
                'vendor_finance.second_password_required.description'.tr(),
                style: AppTextStyles.bodyMedium,
                color: AppColors.neutral5,
                textAlign: TextAlign.center,
              ),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton.filled(
                  label: 'vendor_finance.second_password_required.button'.tr(),
                  onPressed: onCreatePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
