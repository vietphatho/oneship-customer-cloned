import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_check_box.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_radio_group.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';

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
        final isHospitalOrder = state.shopInfo.shopType == ShopType.hospital;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.mediumSpacing,
                  vertical: AppDimensions.mediumSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      "info_confirmation".tr(),
                      style: AppTextStyles.labelLarge,
                      color: AppColors.secondary,
                    ),
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
                            value: request.payer,
                            displayLabel: (item) => item.nameValue.tr(),
                            onChanged: _createOrderBloc.changePayer,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vertical(AppDimensions.mediumSpacing),
                    if (!isHospitalOrder) ...[
                      PrimaryCard(
                        child: Column(
                          children: [
                            _InfoField(
                              label: "shop_name".tr(),
                              value: state.shopInfo.shopName,
                            ),
                            // _InfoField(
                            //   label: "pick_up_time".tr(),
                            //   value: DateTimeUtils.formatDateFromDT(
                            //     request.detail?.pickupDate,
                            //   ),
                            // ),
                            // _InfoField(
                            //   label: "service_type".tr(),
                            //   value: request.serviceCode?.name,
                            // ),
                          ],
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                    ],
                    _RecipientConfirmationCard(
                      isHospitalOrder: isHospitalOrder,
                      request: request,
                    ),
                    if (isHospitalOrder &&
                        request.hospitalMetadata.hasDelegateInfo) ...[
                      AppSpacing.vertical(AppDimensions.mediumSpacing),
                      PrimaryCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              "hospital_delegate_info".tr(),
                              style: AppTextStyles.labelMedium,
                              color: AppColors.neutral2,
                              fontWeight: FontWeight.w700,
                            ),
                            AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                            if (request.hospitalMetadata.hasDelegateName)
                              _InfoField(
                                label: "delegate_name".tr(),
                                value: request
                                    .hospitalMetadata
                                    .displayDelegateName,
                              ),
                            if (request.hospitalMetadata.hasDelegatePhone)
                              _InfoField(
                                label: "delegate_phone".tr(),
                                value: request
                                    .hospitalMetadata
                                    .displayDelegatePhone,
                              ),
                          ],
                        ),
                      ),
                    ],
                    if (state.shopInfo.shopType != ShopType.hospital) ...[
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
                            _InfoField(
                              label: "commodity_type".tr(),
                              value: _createOrderBloc
                                  .selectedCommodityTypeNames(),
                            ),
                            _InfoField(
                              label: "handling_type".tr(),
                              value: _createOrderBloc
                                  .selectedHandlingTypeNames(),
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
                    ],
                    AppSpacing.vertical(AppDimensions.mediumSpacing),
                    const _FeeSession(),
                    AppSpacing.vertical(AppDimensions.largeSpacing),
                    // Checkbox(
                    //   value: state.acceptTerms,
                    //   onChanged: (value) {
                    //     if (value != null) {
                    //       _createOrderBloc.changeAcceptTerms(value);
                    //     }
                    //   },
                    // ),
                    PrimaryCheckBox(
                      label: "accept_terms".tr(),
                      value: state.acceptTerms,
                      onChanged: (value) {
                        if (value != null) {
                          _createOrderBloc.changeAcceptTerms(value);
                        }
                      },
                    ),
                    // const Spacer(),
                  ],
                ),
              ),
            ),

            SafeArea(child: _BottomActionButtons()),
          ],
        );
      },
    );
  }

  void _handleListener(BuildContext context, CreateOrderState state) {
    final resource = state.createOrderResource;
    if (resource != null) {
      switch (resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showSuccessDialog(
            context,
            message: state.updateOrdId != null
                ? "update_order_successfully".tr()
                : "create_order_successfully".tr(),
            onClosed: () {
              getIt.get<OrdersBloc>().fetchOrdersByStatus();
              context.pop();
            },
          );
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(context, message: resource.message);
      }
    }
  }
}

class _BottomActionButtons extends StatelessWidget {
  const _BottomActionButtons();

  @override
  Widget build(BuildContext context) {
    final CreateOrderBloc createOrderBloc = getIt.get();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumSpacing,
        vertical: AppDimensions.mediumSpacing,
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton.outlined(
              label: "previous".tr(),
              onPressed: () {
                createOrderBloc.backToStep(CreateOrderStep.orderInfo);
              },
            ),
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            child: BlocBuilder<CreateOrderBloc, CreateOrderState>(
              bloc: createOrderBloc,
              buildWhen: (pre, cur) =>
                  pre.updateOrdId != cur.updateOrdId ||
                  pre.acceptTerms != cur.acceptTerms,
              builder: (context, state) {
                return SecondaryButton.filled(
                  label: state.updateOrdId != null
                      ? "update_order".tr()
                      : "create_order".tr(),
                  onPressed: state.acceptTerms
                      ? createOrderBloc.createOrder
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipientConfirmationCard extends StatelessWidget {
  const _RecipientConfirmationCard({
    required this.request,
    required this.isHospitalOrder,
  });

  final CreateOrderRequestEntity request;
  final bool isHospitalOrder;

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isHospitalOrder) ...[
            PrimaryText(
              "hospital_patient_info".tr(),
              style: AppTextStyles.labelMedium,
              color: AppColors.neutral2,
              fontWeight: FontWeight.w700,
            ),
            AppSpacing.vertical(AppDimensions.xxSmallSpacing),
          ],
          _InfoField(label: "customer_name".tr(), value: request.customerName),
          _InfoField(label: "phone_number".tr(), value: request.phone),
          _InfoField(label: "province".tr(), value: request.province?.name),
          _InfoField(label: "ward".tr(), value: request.ward?.name),
          _InfoField(label: "address".tr(), value: request.fullAddress),
          if (isHospitalOrder) ...[
            _InfoField(
              label: "medical_record_code".tr(),
              value: request.hospitalMetadata?.medicalRecordCode,
            ),
            _InfoField(
              label: "prescription_number".tr(),
              value: request.hospitalMetadata?.prescriptionNumber,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.value,
    this.subtitle,
    this.labelColor,
    this.valueColor,
    this.labelWeight,
    this.valueWeight,
    this.valueStyle,
  });

  final String label;
  final String? value;
  final String? subtitle;
  final Color? labelColor;
  final Color? valueColor;
  final FontWeight? labelWeight;
  final FontWeight? valueWeight;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxxSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                label,
                style: AppTextStyles.bodyMedium,
                color: labelColor ?? AppColors.neutral5,
                fontWeight: labelWeight,
              ),
              if (subtitle != null)
                PrimaryText(
                  subtitle,
                  style: AppTextStyles.bodyXSmall,
                  color: AppColors.neutral5,
                ),
            ],
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            child: PrimaryText(
              value ?? "--",
              textAlign: TextAlign.right,
              style: valueStyle ?? AppTextStyles.bodyMedium,
              color: valueColor ?? AppColors.neutral2,
              fontWeight: valueWeight ?? FontWeight.w600,
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
      buildWhen: (previous, current) =>
          previous.calculatedFeeResource != current.calculatedFeeResource ||
          previous.request != current.request,
      builder: (context, state) {
        var request = state.request;

        CalculatedDeliveryFeeEntity? fee = state.calculatedFeeResource?.data;
        final distance =
            state.routingToShopResource.data?.distance ??
            request.router?.distance;
        final weight = request.detail?.weight;
        final baseFee = fee?.baseFee;
        final calculatedSurcharges =
            fee?.surcharges ?? const <CalculatedSurchargeEntity>[];
        final surchargeFee = fee?.surchargesFee;
        final surchargeOriginalAmount = surchargeFee?.originalAmount ?? 0;
        final temporaryTotal =
            (baseFee?.originalAmount ?? 0) + surchargeOriginalAmount;
        final deliveryTotal =
            fee?.deliveryFee ??
            (baseFee?.totalAmount ?? 0) + (surchargeFee?.totalAmount ?? 0);

        return PrimaryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: PrimaryText(
                  "fee".tr(),
                  style: AppTextStyles.labelLarge,
                  color: AppColors.neutral2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              _InfoField(
                label: "distance".tr(),
                value: distance == null
                    ? null
                    : "${Utils.mToKm(distance)?.toStringAsFixed(1)} km",
              ),
              _InfoField(
                label: "chargeable_weight".tr(),
                value: weight != null ? "${weight.toInt()} gr" : "--",
              ),
              _InfoField(
                label: _withPercent("delivery_fee".tr(), baseFee?.vatRate),
                value: Utils.formatCurrencyWithUnit(baseFee?.originalAmount),
              ),
              if (calculatedSurcharges.isNotEmpty) ...[
                const Divider(color: AppColors.neutral8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryText(
                    "extra_services".tr(),
                    style: AppTextStyles.bodyMedium,
                    color: AppColors.neutral2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                ...calculatedSurcharges.map(
                  (surcharge) =>
                      _CalculatedSurchargeFeeRow(surcharge: surcharge),
                ),
              ],
              const Divider(color: AppColors.neutral8),
              _InfoField(
                label: "temporary_total".tr(),
                value: Utils.formatCurrencyWithUnit(temporaryTotal),
              ),
              if ((surchargeFee?.vatAmount ?? 0) > 0)
                _InfoField(
                  label: _withPercent("VAT", surchargeFee?.vatRate),
                  value: Utils.formatCurrencyWithUnit(surchargeFee?.vatAmount),
                ),
              if ((baseFee?.vatAmount ?? 0) > 0)
                _InfoField(
                  label: _withPercent("VAT", baseFee?.vatRate),
                  value: Utils.formatCurrencyWithUnit(baseFee?.vatAmount),
                ),
              _InfoField(
                label: "include_vat".tr(),
                subtitle: request.payer.nameValue.tr(),
                value: Utils.formatCurrencyWithUnit(deliveryTotal),
                labelColor: AppColors.neutral2,
                valueColor: AppColors.neutral2,
                labelWeight: FontWeight.w700,
                valueWeight: FontWeight.w700,
                valueStyle: AppTextStyles.labelMedium,
              ),
              const Divider(color: AppColors.neutral8),
              _InfoField(
                label: "cod".tr(),
                value: Utils.formatCurrencyWithUnit(state.codAmount),
                labelColor: AppColors.neutral2,
                valueColor: AppColors.neutral2,
                labelWeight: FontWeight.w700,
                valueWeight: FontWeight.w700,
              ),
              _InfoField(
                label: "total_collect_amount".tr(),
                value: Utils.formatCurrencyWithUnit(state.totalCollectAmount),
                labelColor: AppColors.primary,
                valueColor: AppColors.primary,
                labelWeight: FontWeight.w700,
                valueWeight: FontWeight.w700,
              ),
            ],
          ),
        );
      },
    );
  }

  String _withPercent(String label, int? percent) {
    if (percent == null || percent <= 0) return label;
    return "$label ($percent%)";
  }
}

class _CalculatedSurchargeFeeRow extends StatelessWidget {
  const _CalculatedSurchargeFeeRow({required this.surcharge});

  final CalculatedSurchargeEntity surcharge;

  @override
  Widget build(BuildContext context) {
    return _InfoField(
      label: "${surcharge.name} (${surcharge.vatRate}%)",
      value: Utils.formatCurrencyWithUnit(surcharge.totalAmount),
    );
  }
}

extension _HospitalMetadataConfirmationX on HospitalMetadataEntity? {
  bool get hasDelegateName => displayDelegateName?.isNotEmpty == true;

  bool get hasDelegatePhone => displayDelegatePhone?.isNotEmpty == true;

  bool get hasDelegateInfo => hasDelegateName || hasDelegatePhone;

  String? get displayDelegateName => this?.delegateName?.trim();

  String? get displayDelegatePhone => this?.delegatePhone?.trim();
}
