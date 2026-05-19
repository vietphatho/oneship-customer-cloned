import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/staff_permission_config.dart';

class StaffPermissionSection extends StatelessWidget {
  const StaffPermissionSection({
    super.key,
    required this.group,
    required this.values,
    required this.onChanged,
  });

  final StaffPermissionGroup group;
  final Map<String, bool> values;
  final void Function(String action, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: group.initiallyExpanded,
      dense: true,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      shape: const Border(),
      collapsedShape: const Border(),
      iconColor: AppColors.neutral1,
      collapsedIconColor: AppColors.neutral1,
      title: Row(
        children: [
          Icon(
            group.icon,
            color: AppColors.secondary,
            size: AppDimensions.smallIconSize,
          ),
          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
          PrimaryText(
            group.labelKey.tr(),
            style: AppTextStyles.titleMedium,
            color: AppColors.neutral4,
          ),
        ],
      ),
      children:
          staffPermissionActions.map((action) {
            return _PermissionSwitchRow(
              label: action.labelKey.tr(),
              value: values[action.key] ?? false,
              onChanged: (value) => onChanged(action.key, value),
            );
          }).toList(),
    );
  }
}

class _PermissionSwitchRow extends StatelessWidget {
  const _PermissionSwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.mediumSpacing),
      child: Row(
        children: [
          Expanded(
            child: PrimaryText(
              label,
              style: AppTextStyles.bodyMedium,
              color: AppColors.neutral4,
            ),
          ),
          Transform.scale(
            scale: 0.72,
            alignment: Alignment.centerRight,
            child: Switch(
              value: value,
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: AppColors.neutral7,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
