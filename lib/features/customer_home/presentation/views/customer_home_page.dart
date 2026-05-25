import 'package:flutter/material.dart';
import 'package:oneship_shop/core/themes/app_colors.dart';
import 'package:oneship_shop/features/customer_home/presentation/widgets/customer_order_tracking_input_session.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: AppColors.shopHomeGradBg),
          ),
          Column(children: [const CustomerOrderTrackingInputSession()]),
        ],
      ),
    );
  }
}
