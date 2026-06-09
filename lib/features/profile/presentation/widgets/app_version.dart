import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/main.dart';

class AppVersion extends StatefulWidget {
  const AppVersion({super.key});

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.largeSpacing),
      child: PrimaryText(
        "${"version".tr()}: ${packageInfo.version} (${packageInfo.buildNumber})",
        style: AppTextStyles.bodySmall,
        color: AppColors.neutral6,
      ),
    );
  }
}
