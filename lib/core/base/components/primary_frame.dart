import 'package:oneship_customer/core/base/base_import_components.dart';

class PrimaryFrame extends StatelessWidget {
  const PrimaryFrame({super.key, this.child, this.padding});

  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDimensions.largeBorderRadius,
        border: Border.all(
          color: AppColors.neutral7,
          width: AppDimensions.mediumBorderStroke,
        ),
        color: Colors.white,
      ),
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
      child: child,
    );
  }
}
