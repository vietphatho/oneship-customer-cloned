import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_dialog.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    this.title,
    this.actions,
    this.confirmPop = false,
    this.canPop = true,
    this.backgroundColor = Colors.white,
  });

  final String? title;
  final List<Widget>? actions;

  final bool confirmPop;
  final bool canPop;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !confirmPop,
      onPopInvokedWithResult: (didPop, result) async {
        // didPop sáº½ true náº¿u pop Ä‘Ă£ thĂ nh cĂ´ng (canPop = true)
        // didPop sáº½ false náº¿u pop bá»‹ block (canPop = false)
        if (didPop) {
          return; // Pop Ä‘Ă£ thĂ nh cĂ´ng, khĂ´ng cáº§n xá»­ lĂ½
        }

        // Náº¿u didPop = false, cĂ³ nghÄ©a confirmPop = true vĂ  user báº¥m back
        if (confirmPop) {
          bool? confirmed = false;
          await PrimaryDialog.showQuestionDialog<bool>(
            context,
            message: "are_you_sure_pop".tr(),
            onPositiveTapped: () => confirmed = true,
            onNegativeTapped: () => confirmed = false,
          );

          // Náº¿u user xĂ¡c nháº­n, gá»i pop thĂ´ng qua microtask
          if (confirmed == true) {
            // Äáº£o ngÆ°á»£c confirmPop Ä‘á»ƒ láº§n tá»›i cho phĂ©p pop
            Future.microtask(() {
              Navigator.pop(context);
            });
          }
        }
      },
      child: AppBar(
        backgroundColor: backgroundColor,
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
