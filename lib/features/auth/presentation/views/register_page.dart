import 'package:oneship_customer/core/base/base_import_components.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "register".tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.mediumSpacing,
          vertical: AppDimensions.mediumSpacing,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PrimaryTextField(label: "user_name".tr(), isRequired: true),
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                    PrimaryTextField(label: "full_name".tr(), isRequired: true),
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                    PrimaryTextField(label: "email".tr(), isRequired: true),
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                    PrimaryTextField(
                      label: "phone_number".tr(),
                      isRequired: true,
                    ),
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                    PrimaryTextField(
                      label: "password".tr(),
                      obscureText: true,
                      isRequired: true,
                    ),
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                    PrimaryTextField(
                      label: "confirm_pw".tr(),
                      obscureText: true,
                      isRequired: true,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: PrimaryButton.filled(
                label: "register".tr(),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
