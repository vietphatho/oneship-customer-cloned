import 'package:oneship_customer/core/base/base_import_components.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu_rounded, color: AppColors.secondary),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_rounded, color: AppColors.secondary),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
