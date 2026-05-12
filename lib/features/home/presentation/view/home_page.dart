import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_text_button.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppSpacing.vertical(AppDimensions.largeSpacing),
              Image.asset(ImagePath.logo, width: size.width * 0.7),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryTextButton(
                    label: "log_in".tr(),
                    onPressed: () {
                      context.push(RouteName.loginPage);
                    },
                  ),
                  AppSpacing.horizontal(AppDimensions.smallSpacing),
                  PrimaryTextButton(label: "sign_up".tr(), onPressed: () {
                    context.pushReplacement(RouteName.registerPage);
                  }),
                ],
              ),
              SizedBox(height: 300),
              PrimaryText(
                "Giải pháp giao hàng Chặng cuối thông minh",
                style: AppTextStyles.displaySmall,
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              PrimaryText(
                "Lộ trình tối ưu – Chống giao hàng khống – Tiết kiệm chi phí – Đối soát thần tốc.",
                style: AppTextStyles.bodyMedium,
                color: AppColors.neutral5,
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PrimaryTextField(hintText: "input".tr()),
                  ),
                  AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                  Expanded(child: PrimaryButton.filled(label: "search".tr())),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PrimaryText("CÔNG TY TNHH KỶ NGUYÊN SỐ ONEXWAY"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
