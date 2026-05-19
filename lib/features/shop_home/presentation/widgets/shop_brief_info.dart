import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
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
            horizontal: AppDimensions.mediumSpacing,
          ),
          child: PrimaryCard(
            child: Column(
              children: [
                _InfoField(
                  label: "today_total_orders".tr(),
                  icon: Icons.description_outlined,
                  value: "${data?.totalOrdersPickedUpToday} ${"order".tr()}",
                ),
                const Divider(),
                _InfoField(
                  label: "today_total_cod".tr(),
                  icon: Icons.money_rounded,
                  value: Utils.formatCurrencyWithUnit(
                    data?.totalCodAmountToday,
                  ),
                ),
                const Divider(),
                _InfoField(
                  label: "today_total_expense".tr(),
                  icon: Icons.attach_money_rounded,
                  value: Utils.formatCurrencyWithUnit(
                    data?.totalDeliveryFeeToday,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    // required this.icon,
    required this.icon,
    required this.label,
    required this.value,
  });

  // final String icon;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.secondary,
                  width: AppDimensions.smallBorderStroke,
                ),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(AppDimensions.xxSmallSpacing),
              child: Icon(
                icon,
                color: AppColors.secondary,
                size: AppDimensions.xSmallIconSize,
              ),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            PrimaryText(label, style: AppTextStyles.bodySmall),
          ],
        ),
        PrimaryText(
          value,
          style: AppTextStyles.labelMedium,
          color: AppColors.secondary,
        ),
      ],
    );
  }
}
