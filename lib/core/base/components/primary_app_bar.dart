import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    this.title,
    this.actions,
    this.confirmPop = false,
  });

  final String? title;
  final List<Widget>? actions;

  final bool confirmPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !confirmPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (!confirmPop) return context.pop();

        bool? result;
        await PrimaryDialog.showQuestionDialog<bool>(
          context,
          message: "are_you_sure_pop".tr(),
          onPositiveTapped: () => result = true,
          onNegativeTapped: () => result = false,
        );

        if (result == true) {
          context.pop();
        }
      },
      child: AppBar(
        title: PrimaryText(
          title,
          style: AppTextStyles.appBarTitle,
          color: AppColors.primary,
        ),
        centerTitle: true,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
