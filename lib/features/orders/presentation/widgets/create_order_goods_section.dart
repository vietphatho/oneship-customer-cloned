import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_delivery_service_selector.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_surcharge_section.dart';

class CreateOrderGoodsSection extends StatelessWidget {
  const CreateOrderGoodsSection({
    super.key,
    required this.weightController,
    required this.packageSize,
    required this.noteController,
    required this.onChanged,
    required this.onWeightChanged,
    required this.onPackageSizeChanged,
  });

  final TextEditingController weightController;
  final PackageSize? packageSize;
  final TextEditingController noteController;
  final VoidCallback onChanged;
  final ValueChanged<String> onWeightChanged;
  final ValueChanged<PackageSize?> onPackageSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryTextField(
          label: "weight".tr(),
          isRequired: true,
          controller: weightController,
          keyboardType: TextInputType.number,
          suffixText: Constants.weightUnit,
          onChanged: (value) {
            onWeightChanged(value);
            onChanged();
          },
        ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        _PackageSizeDropdown(
          packageSize: packageSize,
          onChanged: onPackageSizeChanged,
        ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        CreateOrderDeliveryServiceSelector(),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        const CreateOrderSurchargeSection(),
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

class _PackageSizeDropdown extends StatelessWidget {
  const _PackageSizeDropdown({
    required this.packageSize,
    required this.onChanged,
  });

  final PackageSize? packageSize;
  final ValueChanged<PackageSize?> onChanged;

  @override
  Widget build(BuildContext context) {
    final dimensions = packageSize?.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryDropdown<PackageSize>(
          requestFocusOnTap: false,
          label: "dimensions".tr(),
          hintText: "enter_dimensions".tr(),
          menu: PackageSize.values,
          initialValue: packageSize,
          toLabel: (item) => item.displayName,
          onSelected: onChanged,
        ),
        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/icon_create_order_product_box.svg",
              width: AppDimensions.xSmallIconSize,
              height: AppDimensions.xSmallIconSize,
            ),
            AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
            Expanded(
              child: PrimaryText(
                dimensions == null
                    ? "${"dimensions".tr()} (D x R x C)"
                    : "$dimensions ${Constants.pkgDimensionsUnit} (D x R x C)",
                style: AppTextStyles.bodySmall,
                color: AppColors.neutral5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
