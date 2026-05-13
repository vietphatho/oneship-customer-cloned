import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dropdown.dart';
import 'package:oneship_customer/core/base/components/primary_text_field.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/components/secondary_text_button.dart';

class ShopStaffFilterPanel extends StatelessWidget {
  const ShopStaffFilterPanel({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.selectedStatus,
    required this.onStatusSelected,
    required this.onApply,
    required this.onClear,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final String? selectedStatus;
  final ValueChanged<String?> onStatusSelected;
  final VoidCallback onApply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        0,
        AppDimensions.mediumSpacing,
        AppDimensions.mediumSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CompactTextField(
            controller: nameController,
            label: "shop_management.staff_full_name".tr(),
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          _CompactTextField(
            controller: emailController,
            label: "shop_management.field_email".tr(),
            keyboardType: TextInputType.emailAddress,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          PrimaryDropdown<String>(
            key: ValueKey(selectedStatus),
            label: "shop_management.field_status".tr(),
            hintText: "select".tr(),
            initialValue: selectedStatus,
            menu: StaffStatusFilter.filterValues,
            toLabel: StaffStatusFilter.label,
            onSelected: onStatusSelected,
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SecondaryButton.filled(
                  label: "shop_management.filter_result".tr(),
                  onPressed: onApply,
                  height: AppDimensions.smallHeightButton,
                ),
              ),
              AppSpacing.horizontal(AppDimensions.smallSpacing),
              SecondaryTextButton(
                label: "shop_management.clear_filter".tr(),
                onPressed: onClear,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactTextField extends StatelessWidget {
  const _CompactTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: controller,
      label: label,
      hintText: "enter_text".tr(),
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
    );
  }
}

class StaffStatusFilter {
  static const all = "all";
  static const active = "active";
  static const inactive = "inactive";
  static const pending = "pending";

  static const filterValues = [active, inactive, pending];

  static String label(String value) {
    switch (value) {
      case active:
        return "shop_management.status_active".tr();
      case inactive:
        return "shop_management.status_inactive".tr();
      case pending:
        return "shop_management.status_pending".tr();
      default:
        return "shop_management.status_all".tr();
    }
  }
}
