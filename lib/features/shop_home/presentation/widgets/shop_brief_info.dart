import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopBriefInfo extends StatelessWidget {
  const ShopBriefInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopBloc _shopBloc = getIt.get();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: _shopBloc,

      builder: (context, state) {
        ShopDailySummaryEntity? data = state.dailySummaryResource.data;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
          ),
          child: PrimaryCard(
            child: Column(
              children: [
                _InfoField(
                  label: "today_total_orders".tr(),
                  value: "${data?.totalOrdersPickedUpToday} ${"order".tr()}",
                ),
                const Divider(),
                _InfoField(
                  label: "today_total_cod".tr(),
                  value: Utils.formatCurrencyWithUnit(
                    data?.totalCodAmountToday,
                  ),
                ),
                const Divider(),
                _InfoField(
                  label: "today_total_expense".tr(),
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
    super.key,
    // required this.icon,
    required this.label,
    required this.value,
  });

  // final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.ac_unit_rounded),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            PrimaryText(label),
          ],
        ),
        PrimaryText(value),
      ],
    );
  }
}
