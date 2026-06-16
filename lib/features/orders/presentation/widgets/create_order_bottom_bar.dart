import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class CreateOrderBottomBar extends StatelessWidget {
  const CreateOrderBottomBar({super.key, required this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<CreateOrderBloc>();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.mediumSpacing,
          AppDimensions.smallSpacing,
          AppDimensions.mediumSpacing,
          AppDimensions.mediumSpacing,
        ),
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<CreateOrderBloc, CreateOrderState>(
                bloc: bloc,
                buildWhen: (previous, current) =>
                    previous.calculatedFeeResource !=
                        current.calculatedFeeResource ||
                    previous.canCalculateFee != current.canCalculateFee,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PrimaryText(
                        "delivery_fee".tr(),
                        style: AppTextStyles.bodySmall,
                        color: AppColors.neutral5,
                      ),
                      PrimaryText(
                        _feeText(state),
                        color: AppColors.primary,
                        bold: true,
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: PrimaryButton.filled(
                label: "continue".tr(),
                onPressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _feeText(CreateOrderState state) {
    final feeResource = state.calculatedFeeResource;
    if (!state.canCalculateFee) return "--";
    if (feeResource?.state == Result.loading) return "loading".tr();
    final fee = feeResource?.data?.deliveryFee;
    if (fee == null) return "--";
    return Utils.formatCurrencyWithUnit(fee);
  }
}
