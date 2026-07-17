import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/screen_main.dart';
import 'package:url_launcher/url_launcher.dart';

class IncompleteFeaturePage extends StatelessWidget {
  const IncompleteFeaturePage({super.key, this.hasLeading = true});

  final bool hasLeading;

  @override
  Widget build(BuildContext context) {
    return ScreenMain(
      isBack: hasLeading,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.xxLargeSpacing),
              child: Image.asset("assets/images/onboarding_3.png"),
            ),
            AppSpacing.vertical(AppDimensions.largeSpacing),
            const PrimaryText(
              "Tính năng này sẽ sớm có mặt",
              style: AppTextStyles.bodyMedium,
            ),
            AppSpacing.vertical(AppDimensions.largeSpacing),
            PrimaryText(
              "contact_to_coopperate".tr(),
              style: AppTextStyles.titleMedium,
            ),
            GestureDetector(
              onTap: () {
                final uri = Uri(scheme: 'tel', path: "0981191608");
                launchUrl(uri);
              },
              child: PrimaryText(
                "0981191608".tr(),
                style: AppTextStyles.bodyMedium,
              ),
            ),
            PrimaryText(
              "hello@ozoship.vn".tr(),
              style: AppTextStyles.bodyMedium,
            ),
            AppSpacing.vertical(AppDimensions.bottomNavBarHeight),
          ],
        ),
      ),
    );
  }
}
