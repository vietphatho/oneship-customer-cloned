import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';

class GeneralProfileMenuPanel extends StatelessWidget {
  const GeneralProfileMenuPanel({super.key});

  List<PrimaryMenuItemData> _items(BuildContext context) {
    return [
      PrimaryMenuItemData(
        icon: Icons.person_outline_rounded,
        iconColor: AppColors.primary,
        label: 'Thông tin cá nhân',
        onTap: () => context.push(RouteName.profileDetailPage),
      ),
      PrimaryMenuItemData(
        icon: Icons.lock_outline_rounded,
        iconColor: AppColors.info,
        label: 'Cài đặt tài khoản',
        onTap: () => context.push(RouteName.changePasswordPage),
      ),
      const PrimaryMenuItemData(
        icon: Icons.location_on_outlined,
        iconColor: AppColors.green,
        label: 'Địa chỉ lấy hàng',
      ),
      const PrimaryMenuItemData(
        icon: Icons.credit_card_rounded,
        iconColor: AppColors.primary,
        label: 'Phương thức thanh toán',
      ),
      const PrimaryMenuItemData(
        icon: Icons.notifications_none_rounded,
        iconColor: AppColors.error,
        label: 'Thông báo',
      ),
      const PrimaryMenuItemData(
        icon: Icons.language_rounded,
        iconColor: AppColors.investmentPurple,
        label: 'Ngôn ngữ',
        trailingText: 'Tiếng Việt',
      ),
      const PrimaryMenuItemData(
        icon: Icons.support_agent_rounded,
        iconColor: AppColors.info,
        label: 'Trung tâm hỗ trợ',
      ),
      const PrimaryMenuItemData(
        icon: Icons.info_outline_rounded,
        iconColor: AppColors.primary,
        label: 'Giới thiệu về OneShip',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _items(context);

    return PrimaryPanel(
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            PrimaryMenuItem(
              data: items[i],
              showDivider: i != items.length - 1,
            ),
        ],
      ),
    );
  }
}

class GeneralProfileLogoutButton extends StatelessWidget {
  const GeneralProfileLogoutButton({super.key, required this.authBloc});

  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: 'Đăng xuất',
      type: PrimaryActionButtonType.dangerOutlined,
      width: double.infinity,
      icon: const Icon(Icons.logout_rounded),
      onPressed: () {
        PrimaryDialog.showQuestionDialog(
          context,
          title: 'confirm_logout',
          onPositiveTapped: authBloc.logOut,
        );
      },
    );
  }
}
