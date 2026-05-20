import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';

class OrderDetailInfoTabView extends StatelessWidget {
  const OrderDetailInfoTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersBloc _ordersBloc = getIt.get();

    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      builder: (context, state) {
        var ordDtl = state.orderDetailResource.data;
        final shouldShowShipperInfo =
            ordDtl?.status != OrderStatus.pending.value &&
            ordDtl?.status != OrderStatus.processing.value;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: AppDimensions.smallSpacing,
            ),
            child: Column(
              children: [
                PrimaryFrame(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.store_mall_directory_rounded),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            "sender".tr(),
                            style: AppTextStyles.labelLarge,
                          ),
                        ],
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _buildInfoField(
                        label: "shop_name".tr(),
                        value: ordDtl?.shop?.shopName,
                      ),
                      _buildInfoField(
                        label: "phone_number".tr(),
                        value: ordDtl?.shop?.phone,
                      ),
                      _buildInfoField(
                        label: "pick_up_date".tr(),
                        value: DateTimeUtils.formatDateFromDT(
                          ordDtl?.pickupDate,
                        ),
                      ),
                      _buildInfoField(
                        label: "pick_up_session".tr(),
                        value: ordDtl?.pickupTimeSlot,
                      ),
                    ],
                  ),
                ),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                PrimaryFrame(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_rounded),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            "recipient".tr(),
                            style: AppTextStyles.labelLarge,
                          ),
                        ],
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _buildInfoField(
                        label: "customer_name".tr(),
                        value: ordDtl?.customerName,
                      ),
                      _buildInfoField(
                        label: "phone_number".tr(),
                        value: ordDtl?.phone,
                      ),
                      _buildInfoField(
                        label: "address".tr(),
                        value: ordDtl?.fullAddress,
                      ),
                    ],
                  ),
                ),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                PrimaryFrame(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.store_mall_directory_rounded),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            "order_info".tr(),
                            style: AppTextStyles.labelLarge,
                          ),
                        ],
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _buildInfoField(
                        label: "weight".tr(),
                        value: Utils.formatWeightWithUnit(
                          ordDtl?.weight,
                        ),
                      ),
                      _buildInfoField(
                        label: "dimensions".tr(),
                        value: Utils.formatDimensionWithUnit(
                          length: ordDtl?.length,
                          width: ordDtl?.width,
                          height: ordDtl?.height,
                        ),
                      ),
                      _buildInfoField(
                        label: "service".tr(),
                        value: ordDtl?.serviceCode,
                      ),
                      _buildInfoField(
                        label: "cod".tr(),
                        value: Utils.formatCurrencyWithUnit(ordDtl?.codAmount),
                      ),
                    ],
                  ),
                ),
                if (ordDtl?.note?.isEmpty != true) ...[
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  PrimaryFrame(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          "note".tr(),
                          style: AppTextStyles.labelLarge,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: PrimaryText(
                            ordDtl?.note,
                            style: AppTextStyles.bodyMedium,
                            color: AppColors.neutral1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                AppSpacing.vertical(AppDimensions.smallSpacing),
                PrimaryFrame(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.attach_money_rounded),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            "fee".tr(),
                            style: AppTextStyles.labelLarge,
                          ),
                        ],
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _buildInfoField(
                        label: "distance".tr(),
                        value: "${ordDtl?.distance} ${Constants.distanceUnit}",
                      ),
                      _buildInfoField(
                        label: "weight".tr(),
                        value: Utils.formatWeightWithUnit(
                          ordDtl?.weight,
                        ),
                      ),
                      _buildInfoField(
                        label: "shipping_fee".tr(),
                        value: Utils.formatCurrencyWithUnit(
                          ordDtl?.totalFeeAmount,
                        ),
                      ),
                      const Divider(),
                      _OrdersFeeListView(fees: ordDtl?.orderFees ?? []),
                      const Divider(),
                      _buildInfoField(
                        label: "cod".tr(),
                        value: Utils.formatCurrencyWithUnit(ordDtl?.codAmount),
                      ),
                      _buildInfoField(
                        label: "total_collect_amount".tr(),
                        value: Utils.formatCurrencyWithUnit(
                          ordDtl?.collectAmount,
                        ),
                      ),
                    ],
                  ),
                ),
                if (shouldShowShipperInfo) ...[
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  PrimaryFrame(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.delivery_dining_rounded),
                            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                            PrimaryText(
                              "shipper_info".tr(),
                              style: AppTextStyles.labelLarge,
                            ),
                          ],
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        Row(
                          children: [
                            CircleAvatar(),
                            AppSpacing.horizontal(AppDimensions.mediumSpacing),
                            Column(
                              children: [PrimaryText("--"), PrimaryText("--")],
                            ),
                          ],
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        _buildInfoField(
                          label: "shipper_id".tr(),
                          value: ordDtl?.shipperCodes.firstOrNull,
                        ),
                        _buildInfoField(
                          label: "phone_number".tr(),
                          value: null,
                        ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        SecondaryButton.iconFilled(
                          label: "call_right_now".tr(),
                          icon: Icon(Icons.call_rounded, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
                AppSpacing.vertical(AppDimensions.mediumSpacing),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoField({required String label, required String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxxSmallSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            label,
            style: AppTextStyles.bodyMedium,
            fontWeight: FontWeight.w300,
            color: AppColors.neutral5,
          ),
          AppSpacing.horizontal(AppDimensions.mediumSpacing),
          Expanded(
            child: PrimaryText(
              value ?? "--",
              style: AppTextStyles.bodyMedium,
              color: AppColors.neutral1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersFeeListView extends StatelessWidget {
  const _OrdersFeeListView({super.key, required this.fees});

  final List<OrderFeeEntity> fees;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder:
          (context, index) => Column(
            children: [
              _buildInfoField(
                label: "exclude_vat".tr(),
                value: Utils.formatCurrencyWithUnit(fees[index].baseAmount),
              ),
              _buildInfoField(
                label: "VAT (${fees[index].vatRate}%)".tr(),
                value: Utils.formatCurrencyWithUnit(fees[index].vatAmount),
              ),
              _buildInfoField(
                label: "include_vat".tr(),
                value: Utils.formatCurrencyWithUnit(fees[index].totalAmount),
              ),
            ],
          ),
      separatorBuilder:
          (_, __) => AppSpacing.vertical(AppDimensions.xSmallSpacing),
      itemCount: fees.length,
    );
  }

  Row _buildInfoField({required String label, required String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          label,
          style: AppTextStyles.bodyMedium,
          fontWeight: FontWeight.w300,
          color: AppColors.neutral5,
        ),
        Expanded(
          child: PrimaryText(
            value ?? "--",
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral1,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
