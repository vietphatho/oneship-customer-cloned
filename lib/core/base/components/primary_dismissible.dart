import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';

class PrimaryDismissible extends StatelessWidget {
  const PrimaryDismissible({
    required this.key,
    this.onDismissed,
    this.confirmDismiss,
    required this.child,
    required this.confirmMessage,
    this.enable = true,
  });

  final void Function(DismissDirection)? onDismissed;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;
  final Widget child;
  final Key key;
  final String confirmMessage;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    if (!enable) return child;

    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmDialog(context);
      },
      onDismissed: onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.smallSpacing),
        decoration: BoxDecoration(
          color: AppColors.red500,
          borderRadius: AppDimensions.mediumBorderRadius,
        ),
        child: Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: AppDimensions.mediumIconSize,
        ),
      ),
      child: child,
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context) async {
    bool? result;

    await PrimaryDialog.showQuestionDialog(
      context,
      message: confirmMessage,
      positiveButtonText: "delete".tr(),
      onPositiveTapped: () {
        result = true;
      },
      onNegativeTapped: () => result = false,
    );

    return result;
  }
}
