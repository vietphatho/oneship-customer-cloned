import 'package:oneship_customer/core/base/base_import_components.dart';

Future<ProfileAvatarAction?> showProfileAvatarActionSheet(
  BuildContext context,
) {
  return showModalBottomSheet<ProfileAvatarAction>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.xLargeRadius),
      ),
    ),
    builder: (context) => const _ProfileAvatarActionSheet(),
  );
}

enum ProfileAvatarAction { view, change }

class _ProfileAvatarActionSheet extends StatelessWidget {
  const _ProfileAvatarActionSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppDimensions.mediumPaddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.neutral7,
                  borderRadius: AppDimensions.smallBorderRadius,
                ),
              ),
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            _AvatarActionTile(
              icon: Icons.visibility_outlined,
              label: 'view_avatar'.tr(),
              onTap: () => Navigator.pop(context, ProfileAvatarAction.view),
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            _AvatarActionTile(
              icon: Icons.photo_library_outlined,
              label: 'change_avatar'.tr(),
              onTap: () => Navigator.pop(context, ProfileAvatarAction.change),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarActionTile extends StatelessWidget {
  const _AvatarActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PrimaryPanel(
      padding: AppDimensions.mediumPaddingAll,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.neutral3),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          PrimaryText(label, style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}
