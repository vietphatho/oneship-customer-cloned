import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_delivery_service_selector.dart';

class CreateOrderGoodsSection extends StatelessWidget {
  const CreateOrderGoodsSection({
    super.key,
    required this.weightController,
    required this.dimensionsController,
    required this.codController,
    required this.noteController,
    required this.onChanged,
    required this.onCodTap,
  });

  final TextEditingController weightController;
  final TextEditingController dimensionsController;
  final TextEditingController codController;
  final TextEditingController noteController;
  final VoidCallback onChanged;
  final VoidCallback onCodTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryTextField(
                label: "weight".tr(),
                isRequired: true,
                controller: weightController,
                keyboardType: TextInputType.number,
                suffixText: Constants.weightUnit,
                onChanged: (_) => onChanged(),
              ),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            Expanded(
              child: PrimaryTextField(
                label: "${"dimensions".tr()} (D x R x C)",
                hintText: "enter_dimensions".tr(),
                controller: dimensionsController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9xX* ]")),
                ],
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: AppDimensions.xSmallSpacing,
                    right: AppDimensions.smallSpacing,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PrimaryText(
                        Constants.pkgDimensionsUnit,
                        style: AppTextStyles.bodySmall,
                        color: AppColors.neutral5,
                      ),
                      AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                      SvgPicture.asset(
                        "assets/icons/icon_create_order_product_box.svg",
                        width: AppDimensions.xSmallIconSize,
                        height: AppDimensions.xSmallIconSize,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        CreateOrderDeliveryServiceSelector(),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        _CreateOrderSurchargeSection(
          codAmount: Utils.parseCurrencyInput(codController.text),
          onCodTap: onCodTap,
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        PrimaryTextField(
          label: "note".tr(),
          hintText: "note_hint".tr(),
          controller: noteController,
          maxLength: 200,
          maxLine: 2,
        ),
      ],
    );
  }
}

class _CreateOrderSurchargeSection extends StatelessWidget {
  const _CreateOrderSurchargeSection({
    required this.codAmount,
    required this.onCodTap,
  });

  final int codAmount;
  final VoidCallback onCodTap;

  static const _items = [
    ("door_delivery_fee", Icons.location_on_outlined, false),
    ("appointment_delivery_fee", Icons.calendar_month_outlined, false),
    ("cod", Icons.payments_outlined, true),
    ("return_document_fee", Icons.description_outlined, false),
    ("packing_fee", Icons.inventory_2_outlined, false),
    ("special_request_fee", Icons.assignment_outlined, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          "surcharge".tr(),
          style: AppTextStyles.bodySmall,
          bold: true,
        ),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppDimensions.xSmallSpacing,
          crossAxisSpacing: AppDimensions.xSmallSpacing,
          childAspectRatio: 3.1,
          children: _items.map(_item).toList(),
        ),
      ],
    );
  }

  Widget _item((String, IconData, bool) item) {
    final isCod = item.$3;

    return InkWell(
      onTap: isCod ? onCodTap : null,
      borderRadius: AppDimensions.largeBorderRadius,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.neutral8),
          borderRadius: AppDimensions.largeBorderRadius,
        ),
        child: Row(
          children: [
            Icon(
              item.$2,
              size: AppDimensions.xxSmallIconSize,
              color: AppColors.neutral5,
            ),
            AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
            Expanded(
              child: PrimaryText(item.$1.tr(), style: AppTextStyles.bodySmall),
            ),
            PrimaryText(
              Utils.formatCurrencyWithUnit(isCod ? codAmount : 0),
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
