import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    this.title,
    this.actions,
    this.confirmPop = false,
    this.canPop = true,
  });

  final String? title;
  final List<Widget>? actions;

  final bool confirmPop;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !confirmPop,
      onPopInvokedWithResult: (didPop, result) async {
        // didPop sẽ true nếu pop đã thành công (canPop = true)
        // didPop sẽ false nếu pop bị block (canPop = false)
        if (didPop) {
          return; // Pop đã thành công, không cần xử lý
        }

        // Nếu didPop = false, có nghĩa confirmPop = true và user bấm back
        if (confirmPop) {
          bool? confirmed = false;
          await PrimaryDialog.showQuestionDialog<bool>(
            context,
            message: "are_you_sure_pop".tr(),
            onPositiveTapped: () => confirmed = true,
            onNegativeTapped: () => confirmed = false,
          );

          // Nếu user xác nhận, gọi pop thông qua microtask
          if (confirmed == true) {
            // Đảo ngược confirmPop để lần tới cho phép pop
            Future.microtask(() {
              Navigator.pop(context);
            });
          }
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
        automaticallyImplyLeading: canPop,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
