import 'package:oneship_customer/core/base/base_import_components.dart';

class OrderStatusTag extends StatelessWidget {
  const OrderStatusTag({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accentColor1,
        borderRadius: AppDimensions.mediumBorderRadius,
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.xxSmallSpacing,
        horizontal: AppDimensions.xSmallSpacing,
      ),
      child: PrimaryText(
        status.tr(),
        style: AppTextStyles.labelXSmall,
        color: Colors.white,
      ),
    );
  }
}
