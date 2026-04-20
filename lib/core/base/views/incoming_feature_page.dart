

import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/screen_main.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_spacing.dart';

class IncomingFeaturePage extends StatelessWidget {
  const IncomingFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenMain(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.largeSpacing),
              child: Image.asset("assets/images/onboarding_3.png"),
            ),
            AppSpacing.vertical(AppDimensions.largeSpacing),
            // const CustomText(
            //   text: "Tính năng này sẽ sớm có mặt",
            //   textStyle: AppTextStyles.titleLarge,
            // ),
          ],
        ),
      ),
    );
  }
}
