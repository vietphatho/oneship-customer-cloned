import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_avatar.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/utils/string_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_fee_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_detail_info_components.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalOrderDetailInfoTabView extends StatelessWidget {
  const HospitalOrderDetailInfoTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersBloc ordersBloc = getIt.get();

    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: ordersBloc,
      builder: (context, state) {
        final ordDtl = state.orderDetailResource.data;
        if (ordDtl == null) {
          return const SizedBox.shrink();
        }

        final shouldShowShipperInfo =
            ordDtl.status != OrderStatus.pending.value &&
            ordDtl.status != OrderStatus.processing.value;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: AppDimensions.smallSpacing,
            ),
            child: Column(
              children: [
                _HospitalSenderInfoSection(ordDtl: ordDtl),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                HospitalRecipientInfoSection(ordDtl: ordDtl),
                if (ordDtl.hospitalMetadata.hasDelegateInfo) ...[
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  HospitalDelegateInfoSection(
                    metadata: ordDtl.hospitalMetadata!,
                  ),
                ],
                AppSpacing.vertical(AppDimensions.smallSpacing),
                HospitalServiceInfoSection(ordDtl: ordDtl),
                if (ordDtl.note?.isNotEmpty == true) ...[
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  _HospitalNoteSection(note: ordDtl.note!),
                ],
                AppSpacing.vertical(AppDimensions.smallSpacing),
                _HospitalFeeSection(ordDtl: ordDtl),
                if (shouldShowShipperInfo) ...[
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  _HospitalShipperInfoSection(ordDtl: ordDtl),
                ],
                AppSpacing.vertical(AppDimensions.mediumSpacing),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HospitalRecipientInfoSection extends StatelessWidget {
  const HospitalRecipientInfoSection({super.key, required this.ordDtl});

  final OrderDetailEntity ordDtl;

  @override
  Widget build(BuildContext context) {
    final metadata = ordDtl.hospitalMetadata;

    return _HospitalInfoSection(
      icon: Icons.person_rounded,
      title: "hospital_patient_info".tr(),
      children: [
        _HospitalInfoField(
          label: "customer_name".tr(),
          value: ordDtl.customerName,
        ),
        _HospitalInfoField(label: "phone_number".tr(), value: ordDtl.phone),
        _HospitalInfoField(label: "address".tr(), value: ordDtl.fullAddress),
        _HospitalInfoField(
          label: "medical_record_code".tr(),
          value: metadata?.medicalRecordCode,
        ),
        _HospitalInfoField(
          label: "prescription_number".tr(),
          value: metadata?.prescriptionNumber,
        ),
      ],
    );
  }
}

class HospitalDelegateInfoSection extends StatelessWidget {
  const HospitalDelegateInfoSection({super.key, required this.metadata});

  final OrderDetailHospitalMetadataEntity metadata;

  @override
  Widget build(BuildContext context) {
    return _HospitalInfoSection(
      icon: Icons.assignment_ind_rounded,
      title: "hospital_delegate_info".tr(),
      children: [
        if (metadata.hasDelegateName)
          _HospitalInfoField(
            label: "delegate_name".tr(),
            value: metadata.delegateName,
          ),
        if (metadata.hasDelegatePhone)
          _HospitalInfoField(
            label: "delegate_phone".tr(),
            value: metadata.delegatePhone,
          ),
      ],
    );
  }
}

class HospitalServiceInfoSection extends StatelessWidget {
  const HospitalServiceInfoSection({super.key, required this.ordDtl});

  final OrderDetailEntity ordDtl;

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return _HospitalInfoSection(
      icon: Icons.store_mall_directory_rounded,
      title: "hospital_service_info".tr(),
      children: [
        _HospitalInfoField(label: "service".tr(), value: ordDtl.serviceCode),
        BlocBuilder<ShopBloc, ShopState>(
          bloc: shopBloc,
          buildWhen: (previous, current) =>
              previous.visibleSurchargeGroupsResource !=
              current.visibleSurchargeGroupsResource,
          builder: (context, shopState) {
            return _HospitalInfoField(
              label: "extra_services".tr(),
              value: ordDtl.orderFees.displaySurchargeNames(
                shopState.visibleSurchargeGroups,
              ),
            );
          },
        ),
        _HospitalInfoField(
          label: "cod".tr(),
          value: Utils.formatCurrencyWithUnit(ordDtl.codAmount),
        ),
      ],
    );
  }
}

class _HospitalSenderInfoSection extends StatelessWidget {
  const _HospitalSenderInfoSection({required this.ordDtl});

  final OrderDetailEntity ordDtl;

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();
    final currentShop = shopBloc.state.currentShop;

    return _HospitalInfoSection(
      icon: Icons.store_mall_directory_rounded,
      title: "sender".tr(),
      children: [
        _HospitalInfoField(
          label: "shop".tr(),
          value: ordDtl.shop?.shopName ?? currentShop?.shopName,
        ),
        _HospitalInfoField(
          label: "phone_number".tr(),
          value: ordDtl.shop?.phone ?? currentShop?.phone,
        ),
      ],
    );
  }
}

class _HospitalNoteSection extends StatelessWidget {
  const _HospitalNoteSection({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return PrimaryFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText("note".tr(), style: AppTextStyles.labelLarge),
          SizedBox(
            width: double.maxFinite,
            child: PrimaryText(
              note,
              style: AppTextStyles.bodyMedium,
              color: AppColors.neutral1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HospitalFeeSection extends StatelessWidget {
  const _HospitalFeeSection({required this.ordDtl});

  final OrderDetailEntity ordDtl;

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return _HospitalInfoSection(
      icon: Icons.attach_money_rounded,
      title: "fee".tr(),
      children: [
        _HospitalInfoField(
          label: "distance".tr(),
          value: ordDtl.distance != null
              ? "${ordDtl.distance} ${Constants.distanceUnit}"
              : null,
        ),
        _HospitalInfoField(
          label: "shipping_fee".tr(),
          value: Utils.formatCurrencyWithUnit(ordDtl.totalFeeAmount),
        ),
        const Divider(),
        BlocBuilder<ShopBloc, ShopState>(
          bloc: shopBloc,
          buildWhen: (previous, current) =>
              previous.visibleSurchargeGroupsResource !=
              current.visibleSurchargeGroupsResource,
          builder: (context, shopState) {
            return OrderDetailFeeListView(
              fees: ordDtl.orderFees
                  .map(
                    (fee) =>
                        fee.toDisplayEntity(shopState.visibleSurchargeGroups),
                  )
                  .toList(),
            );
          },
        ),
        const Divider(),
        _HospitalInfoField(
          label: "cod".tr(),
          value: Utils.formatCurrencyWithUnit(ordDtl.codAmount),
        ),
        _HospitalInfoField(
          label: "total_collect_amount".tr(),
          value: Utils.formatCurrencyWithUnit(ordDtl.collectAmount),
        ),
      ],
    );
  }
}

class _HospitalShipperInfoSection extends StatelessWidget {
  const _HospitalShipperInfoSection({required this.ordDtl});

  final OrderDetailEntity ordDtl;

  @override
  Widget build(BuildContext context) {
    final shipperPhone = ordDtl.shipper?.phone?.trim();

    return _HospitalInfoSection(
      icon: Icons.delivery_dining_rounded,
      title: "shipper_info".tr(),
      children: [
        Row(
          children: [
            PrimaryAvatar(
              url: StringUtils.getImgUrl(ordDtl.shipper?.avatarUrl),
            ),
            AppSpacing.horizontal(AppDimensions.mediumSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(ordDtl.shipper?.name),
                PrimaryText(ordDtl.shipper?.phone),
              ],
            ),
          ],
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        SecondaryButton.iconFilled(
          label: "call_right_now".tr(),
          icon: Icon(Icons.call_rounded, color: Colors.white),
          onPressed: shipperPhone?.isNotEmpty == true
              ? () => _callShipper(context, shipperPhone!)
              : null,
        ),
      ],
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
}

class _HospitalInfoSection extends StatelessWidget {
  const _HospitalInfoSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return PrimaryFrame(
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.secondary),
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              PrimaryText(
                title,
                style: AppTextStyles.labelLarge,
                color: AppColors.secondary,
              ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          ...children,
        ],
      ),
    );
  }
}

class _HospitalInfoField extends StatelessWidget {
  const _HospitalInfoField({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
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
              value.displayValue,
              style: AppTextStyles.bodySmall,
              color: AppColors.neutral1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

extension _NullableHospitalMetadataX on OrderDetailHospitalMetadataEntity? {
  bool get hasDelegateInfo => this?.hasDelegateInfo == true;
}

extension _OrderFeeHospitalDisplayX on List<OrderFeeEntity> {
  String? displaySurchargeNames(List<SurchargeGroupEntity> groups) {
    final names = surchargeFees
        .map((fee) => fee.toDisplayEntity(groups).label.trim())
        .where((label) => label.isNotEmpty)
        .toSet()
        .join(", ");

    return names.isNotEmpty ? names : null;
  }
}

extension _StringHospitalDetailDisplayX on String? {
  String get displayValue {
    final value = this?.trim();
    return value?.isNotEmpty == true ? value! : "--";
  }
}
