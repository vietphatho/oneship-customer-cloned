import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopBriefInfo extends StatelessWidget {
  const ShopBriefInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen:
          (previous, current) =>
              previous.dailySummaryResource != current.dailySummaryResource,
      builder: (context, state) {
        final data = state.dailySummaryResource.data;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
          ),
          child: PrimaryPanel(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            borderRadius: AppDimensions.largeBorderRadius,
            child: Row(
              children: [
                Expanded(
                  child: _InfoField(
                    label: "shop_home.today_orders".tr(),
                    icon: Icons.description_outlined,
                    value: "${data?.totalOrdersPickedUpToday ?? 0}",
                    unit: "shop_home.order_unit".tr(),
                    color: AppColors.warningForeground,
                  ),
                ),
                const _VerticalDivider(),
                Expanded(
                  child: _InfoField(
                    label: "shop_home.today_cod".tr(),
                    icon: Icons.money_rounded,
                    value: _formatAmount(
                      data?.totalCodAmountToday,
                    ),
                    unit: "shop_home.currency_unit".tr(),
                    color: AppColors.secondary,
                  ),
                ),
                const _VerticalDivider(),
                Expanded(
                  child: _InfoField(
                    label: "shop_home.delivery_fee".tr(),
                    icon: Icons.attach_money_rounded,
                    value: _formatAmount(
                      data?.totalDeliveryFeeToday,
                    ),
                    unit: "shop_home.currency_unit".tr(),
                    color: AppColors.successForeground,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatAmount(num? value) {
    return value == null ? "--" : Utils.formatCurrencyInput(value);
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  icon,
                  color: AppColors.onPrimary,
                  size: 16,
                ),
              ),
              AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
              Expanded(
                child: PrimaryText(
                  label,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelXSmall,
                  color: AppColors.neutral2,
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: PrimaryText(
                value,
                maxLine: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium,
                color: color,
              ),
            ),
            AppSpacing.horizontal(AppDimensions.xxxSmallSpacing),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: PrimaryText(
                unit,
                maxLine: 1,
                style: AppTextStyles.bodySmall,
                color: AppColors.neutral5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.smallBorderStroke,
      height: 50,
      margin: AppDimensions.xxSmallPaddingHorizontal,
      color: AppColors.neutral8,
    );
  }
}
