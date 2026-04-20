// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:oneship_customer/core/base/components/primary_text.dart';
// import 'package:oneship_customer/core/themes/app_dimensions.dart';
// import 'package:oneship_customer/core/themes/app_spacing.dart';
// import 'package:oneship_customer/core/navigation/route_name.dart';

// class UserRoleSelectionPage extends StatefulWidget {
//   const UserRoleSelectionPage({super.key});

//   @override
//   State<UserRoleSelectionPage> createState() => _UserRoleSelectionPageState();
// }

// class _UserRoleSelectionPageState extends State<UserRoleSelectionPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             PrimaryText("select_user_role"),
//             AppSpacing.vertical(AppDimensions.largeSpacing),
//             _UserRoleButton(
//               icon: Icons.account_circle_sharp,
//               onTap: () {
//                 //
//               },
//             ),
//             AppSpacing.vertical(AppDimensions.largeSpacing),
//             _UserRoleButton(
//               icon: Icons.shop_rounded,
//               onTap: () {
//                 context.pushReplacement(RouteName.loginPage);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _UserRoleButton extends StatelessWidget {
//   final IconData icon;
//   final void Function()? onTap;

//   const _UserRoleButton({super.key, required this.icon, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: onTap,
//       icon: Icon(icon, size: AppDimensions.largeIconSize),
//     );
//   }
// }
