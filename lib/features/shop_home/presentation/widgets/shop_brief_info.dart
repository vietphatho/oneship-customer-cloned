import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
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
      buildWhen: (previous, current) =>
          previous.dailySummaryResource != current.dailySummaryResource,
      builder: (context, state) {
        final data = state.dailySummaryResource.data;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
          ),
          child: PrimaryPanel(
            height: 84,
            padding: const EdgeInsets.fromLTRB(14, 9, 14, 8),
            borderRadius: AppDimensions.largeBorderRadius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  'Hôm nay',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                  color: AppColors.neutral3,
                ),
                const Spacer(),
                SizedBox(
                  height: 44,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _InfoField(
                          label: "shop_home.order_unit".tr(),
                          value: "${data?.totalOrdersPickedUpToday ?? 0}",
                          color: AppColors.warningForeground,
                        ),
                      ),
                      const _VerticalDivider(),
                      Expanded(
                        child: _InfoField(
                          label: "COD",
                          value: _formatCompactAmount(
                            data?.totalCodAmountToday,
                          ),
                          color: AppColors.secondary,
                        ),
                      ),
                      const _VerticalDivider(),
                      Expanded(
                        child: _InfoField(
                          label: "shop_home.delivery_fee".tr(),
                          value: _formatCompactAmount(
                            data?.totalDeliveryFeeToday,
                          ),
                          color: AppColors.successForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatCompactAmount(num? value) {
    if (value == null) return "--";

    final absValue = value.abs();
    if (absValue >= 1000000) {
      return '${_formatCompactNumber(value / 1000000)}tr';
    }

    if (absValue >= 1000) {
      return '${_formatCompactNumber(value / 1000)}k';
    }

    return _formatCompactNumber(value);
  }

  String _formatCompactNumber(num value) {
    final rounded = value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
    return rounded.endsWith('.0')
        ? rounded.substring(0, rounded.length - 2)
        : rounded;
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: PrimaryText(
            value,
            maxLine: 1,
            style: AppTextStyles.titleXXXLarge.copyWith(
              fontSize: 22,
              height: 1,
            ),
            color: color,
          ),
        ),
        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
        PrimaryText(
          label,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(fontSize: 12, height: 1),
          color: AppColors.neutral5,
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
      height: 36,
      margin: AppDimensions.smallPaddingHorizontal,
      color: AppColors.neutral8,
    );
  }
}
