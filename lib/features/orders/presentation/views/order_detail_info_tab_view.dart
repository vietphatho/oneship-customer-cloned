import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_avatar.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/utils/string_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/resolve_order_detail_vendor_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_detail_info_components.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/order_option_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailInfoTabView extends StatelessWidget {
  const OrderDetailInfoTabView({super.key});

  static const _resolveVendor = ResolveOrderDetailVendorUseCase();

  @override
  Widget build(BuildContext context) {
    final OrdersBloc ordersBloc = getIt.get();
    final ShopBloc shopBloc = getIt.get();

    var currentShop = shopBloc.state.currentShop;

    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: ordersBloc,
      builder: (context, state) {
        var ordDtl = state.orderDetailResource.data;
        final shouldShowShipperInfo =
            ordDtl?.status != OrderStatus.pending.value &&
            ordDtl?.status != OrderStatus.processing.value;
        final shipperPhone = ordDtl?.shipper?.phone?.trim();

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
                          Icon(
                            Icons.store_mall_directory_rounded,
                            color: AppColors.secondary,
                          ),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            "sender".tr(),
                            style: AppTextStyles.labelLarge,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _buildInfoField(
                        label: "shop".tr(),
                        value: ordDtl?.shop?.shopName ?? currentShop?.shopName,
                      ),
                      _buildInfoField(
                        label: "phone_number".tr(),
                        value: ordDtl?.shop?.phone ?? currentShop?.phone,
                      ),
                      BlocBuilder<ShopBloc, ShopState>(
                        bloc: shopBloc,
                        buildWhen: (previous, current) =>
                            previous.shopVendorsResource !=
                            current.shopVendorsResource,
                        builder: (context, shopState) {
                          final vendor = _resolveVendor(
                            order: ordDtl,
                            vendors: shopState.shopVendors,
                          );
                          if (vendor == null) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              _buildInfoField(
                                label: "Tiểu thương",
                                value: vendor.vendorName,
                              ),
                              _buildInfoField(
                                label: "Địa chỉ",
                                value: vendor.fullAddress,
                              ),
                            ],
                          );
                        },
                      ),
                      // _buildInfoField(
                      //   label: "pick_up_date".tr(),
                      //   value: DateTimeUtils.formatDateFromDT(
                      //     ordDtl?.pickupDate,
                      //   ),
                      // ),
                      // _buildInfoField(
                      //   label: "pick_up_session".tr(),
                      //   value: ordDtl?.pickupTimeSlot,
                      // ),
                    ],
                  ),
                ),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                PrimaryFrame(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            color: AppColors.secondary,
                          ),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            "recipient".tr(),
                            style: AppTextStyles.labelLarge,
                            color: AppColors.secondary,
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
                          Icon(
                            Icons.store_mall_directory_rounded,
                            color: AppColors.secondary,
                          ),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            "order_info".tr(),
                            style: AppTextStyles.labelLarge,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _buildInfoField(
                        label: "weight".tr(),
                        value: Utils.formatWeightWithUnit(ordDtl?.weight),
                      ),
                      _buildInfoField(
                        label: "dimensions".tr(),
                        value:
                            "${ordDtl?.packageSize?.displayName}"
                            " (${ordDtl?.packageSize?.dimensions})",
                      ),
                      BlocBuilder<ShopBloc, ShopState>(
                        bloc: shopBloc,
                        buildWhen: (previous, current) =>
                            previous.commodityTypesResource !=
                                current.commodityTypesResource ||
                            previous.handlingTypesResource !=
                                current.handlingTypesResource,
                        builder: (context, shopState) {
                          return Column(
                            children: [
                              _buildInfoField(
                                label: "commodity_type".tr(),
                                value: _displayOrderOptionNames(
                                  codes: ordDtl?.commodityType ?? const [],
                                  options: shopState.commodityTypes,
                                ),
                              ),
                              _buildInfoField(
                                label: "handling_type".tr(),
                                value: _displayOrderOptionNames(
                                  codes: ordDtl?.handlingType ?? const [],
                                  options: shopState.handlingTypes,
                                ),
                              ),
                            ],
                          );
                        },
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
                if (ordDtl?.note?.isNotEmpty == true) ...[
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
                          Icon(
                            Icons.attach_money_rounded,
                            color: AppColors.secondary,
                          ),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            "fee".tr(),
                            style: AppTextStyles.labelLarge,
                            color: AppColors.secondary,
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
                        value: Utils.formatWeightWithUnit(ordDtl?.weight),
                      ),
                      _buildInfoField(
                        label: "shipping_fee".tr(),
                        value: Utils.formatCurrencyWithUnit(
                          ordDtl?.totalFeeAmount,
                        ),
                      ),
                      const Divider(),
                      BlocBuilder<ShopBloc, ShopState>(
                        bloc: shopBloc,
                        buildWhen: (previous, current) =>
                            previous.visibleSurchargeGroupsResource !=
                            current.visibleSurchargeGroupsResource,
                        builder: (context, shopState) {
                          return OrderDetailFeeListView(
                            fees: (ordDtl?.orderFees ?? [])
                                .map(
                                  (fee) => fee.toDisplayEntity(
                                    shopState.visibleSurchargeGroups,
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
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
                            Icon(
                              Icons.delivery_dining_rounded,
                              color: AppColors.secondary,
                            ),
                            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                            PrimaryText(
                              "shipper_info".tr(),
                              style: AppTextStyles.labelLarge,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        Row(
                          children: [
                            // CircleAvatar(
                            //   backgroundImage: NetworkImage(
                            //     StringUtils.getImgUrl(
                            //           ordDtl?.shipper?.avatarUrl,
                            //         ) ??
                            //         "",
                            //   ),
                            // ),
                            PrimaryAvatar(
                              url: StringUtils.getImgUrl(
                                ordDtl?.shipper?.avatarUrl,
                              ),
                            ),

                            AppSpacing.horizontal(AppDimensions.mediumSpacing),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryText(ordDtl?.shipper?.name),
                                PrimaryText(ordDtl?.shipper?.phone),
                              ],
                            ),
                          ],
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        // _buildInfoField(
                        //   label: "shipper_id".tr(),
                        //   value: ordDtl?.shipperCodes.firstOrNull,
                        // ),
                        // _buildInfoField(
                        //   label: "phone_number".tr(),
                        //   value: null,
                        // ),
                        AppSpacing.vertical(AppDimensions.mediumSpacing),
                        SecondaryButton.iconFilled(
                          label: "call_right_now".tr(),
                          icon: Icon(Icons.call_rounded, color: Colors.white),
                          onPressed: shipperPhone?.isNotEmpty == true
                              ? () => _callShipper(context, shipperPhone!)
                              : null,
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

  Future<void> _callShipper(BuildContext context, String phone) async {
    final phoneNumber = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: phoneNumber);

    if (phoneNumber.isEmpty || !await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('network_error_mess'.tr())));
    }
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
            style: AppTextStyles.bodySmall,
            fontWeight: FontWeight.w300,
            color: AppColors.neutral5,
          ),
          AppSpacing.horizontal(AppDimensions.mediumSpacing),
          Expanded(
            child: PrimaryText(
              value ?? "--",
              style: AppTextStyles.bodySmall,
              color: AppColors.neutral1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String? _displayOrderOptionNames({
    required List<String> codes,
    required List<OrderOptionEntity> options,
  }) {
    final displayNames = options.displayNamesForCodes(codes);
    return displayNames.isNotEmpty ? displayNames : null;
  }
}
