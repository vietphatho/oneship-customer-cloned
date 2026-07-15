import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';

class ProfileBackgroundScaffold extends StatelessWidget {
  static const double backgroundHeight = 136;

  const ProfileBackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.showBodyBackground = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool showBodyBackground;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.getSize(context);

    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: AppColors.background)),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            ImagePath.profileDetailBackground,
            width: size.width,
            height: backgroundHeight,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: appBar,
          body: showBodyBackground
              ? Container(color: AppColors.background, child: body)
              : body,
        ),
      ],
    );
  }
}
