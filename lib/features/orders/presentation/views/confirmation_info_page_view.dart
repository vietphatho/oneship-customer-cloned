import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_radio_group.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class ConfirmationInfoPageView extends StatefulWidget {
  const ConfirmationInfoPageView({super.key});

  @override
  State<ConfirmationInfoPageView> createState() =>
      _ConfirmationInfoPageViewState();
}

class _ConfirmationInfoPageViewState extends State<ConfirmationInfoPageView> {
  final CreateOrderBloc _createOrderBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      // buildWhen:
      //     (pre, cur) =>
      //         pre.request.detail?.pickupDate != cur.request.detail?.pickupDate,
      listener: _handleListener,
      builder: (context, state) {
        final request = state.request;
        final isStepValid =
            request.detail?.pickupDate != null &&
            request.detail?.pickupSession != null &&
            (request.customerName?.trim().isNotEmpty ?? false) &&
            (request.phone?.trim().isNotEmpty ?? false) &&
            (request.fullAddress?.trim().isNotEmpty ?? false) &&
            request.province != null &&
            request.ward != null &&
            (request.detail?.weight ?? 0) > 0;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText("info_confirmation".tr()),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      PrimaryCard(
                        child: Column(
                          children: [
                            _InfoField(
                              label: "shop_name".tr(),
                              value: state.shopInfo.shopName,
                            ),
                            _InfoField(
                              label: "pick_up_time".tr(),
                              value: DateTimeUtils.formatDateFromDT(
                                request.detail?.pickupDate,
                              ),
                            ),
                            _InfoField(
                              label: "service_type".tr(),
                              value: request.serviceCode?.name,
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      PrimaryCard(
                        child: Column(
                          children: [
                            _InfoField(
                              label: "customer_name".tr(),
                              value: request.customerName,
                            ),
                            _InfoField(
                              label: "phone_number".tr(),
                              value: request.phone,
                            ),
                            _InfoField(
                              label: "address_type".tr(),
                              value:
                                  (request.isNewAddress ?? true)
                                      ? "new_address".tr()
                                      : "old_address".tr(),
                            ),
                            _InfoField(
                              label: "province".tr(),
                              value: request.province?.name,
                            ),
                            _InfoField(
                              label: "ward".tr(),
                              value: request.ward?.name,
                            ),
                            _InfoField(
                              label: "address".tr(),
                              value: request.fullAddress,
                            ),

                            // _InfoField(label: "shop_name".tr(), value: ""),
                            // _InfoField(label: "shop_name".tr(), value: ""),
                          ],
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      PrimaryCard(
                        child: Column(
                          children: [
                            _InfoField(
                              label: "weight".tr(),
                              value: Utils.formatWeightWithUnit(
                                request.detail?.weight,
                              ),
                            ),
                            _InfoField(
                              label: "dimensions".tr(),
                              value: Utils.formatDimensionWithUnit(
                                length: request.detail?.length,
                                width: request.detail?.width,
                                height: request.detail?.height,
                              ),
                            ),

                            // _InfoField(
                            //   label: "cod".tr(),
                            //   value: Utils.formatCurrencyWithUnit(
                            //     request.codAmount,
                            //   ),
                            // ),
                            _InfoField(
                              label: "note".tr(),
                              value: request.detail?.note,
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      const _FeeSession(),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      PrimaryCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              "payer".tr(),
                              style: AppTextStyles.labelMedium,
                            ),
                            PrimaryRadioGroup<Payer>(
                              direction: Axis.horizontal,
                              options: Payer.values,
                              value: Payer.recipient,
                              displayLabel: (item) => item.name,
                              onChanged: (item) {},
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.largeSpacing),
                      // const Spacer(),
                    ],
                  ),
                ),
              ),

              SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton.secondaryButton(
                        label: "previous".tr(),
                        onPressed: _onPrevious,
                      ),
                    ),
                    AppSpacing.horizontal(AppDimensions.smallSpacing),
                    Expanded(
                      child: PrimaryButton.primaryButton(
                        label: "confirm".tr(),
                        onPressed:
                            isStepValid
                                ? () {
                                  _createOrderBloc.createOrder();
                                }
                                : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPrevious() {
    // _createOrderBloc.changeStep(CreateOrderStep.receiverInfo);
    _createOrderBloc.backToStep(CreateOrderStep.orderInfo);
  }

  void _handleListener(BuildContext context, CreateOrderState state) {
    if (state is CreateOrderCreatedState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showSuccessDialog(
            context,
            message: "create_order_successfully".tr(),
            onClosed: () {
              context.pop();
            },
          );
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(
            context,
            message: state.resource.message,
          );
      }
    }
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxxSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            "$label: ",
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral5,
          ),
          Expanded(
            child: PrimaryText(
              value ?? "--",
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium,
              color: AppColors.neutral2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeSession extends StatelessWidget {
  const _FeeSession();

  @override
  Widget build(BuildContext context) {
    final CreateOrderBloc createOrderBloc = getIt.get();

    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: createOrderBloc,
      buildWhen: (_, state) => state is CreateOrderCalculatedFeeState,
      builder: (context, state) {
        var request = state.request;
        if (state is! CreateOrderCalculatedFeeState) return SizedBox();

        CalculatedDeliveryFeeEntity? fee = state.resource.data;
        return PrimaryCard(
          child: Column(
            children: [
              _InfoField(
                label: "distance".tr(),
                value:
                    "${Utils.mToKm(state.routingToShopResource.data?.distance)?.toStringAsFixed(1)}"
                    " km",
              ),
              _InfoField(
                label: "cod".tr(),
                value: Utils.formatCurrencyWithUnit(request.codAmount),
              ),
              _InfoField(
                label: "gross_fee".tr(),
                value: Utils.formatCurrencyWithUnit(
                  fee?.baseFee?.originalAmount,
                ),
              ),
              _InfoField(
                label: "VAT (${fee?.baseFee?.vatRate})".tr(),
                value: Utils.formatCurrencyWithUnit(fee?.baseFee?.vatAmount),
              ),
              _InfoField(
                label: "total".tr(),
                value: Utils.formatCurrencyWithUnit(fee?.deliveryFee),
              ),
              // _InfoField(
              //   label: "total".tr(),
              //   value: Utils.formatCurrencyWithUnit(
              //     ( ?? 0) +
              //         (state.resource.data?.vat ?? 0),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
