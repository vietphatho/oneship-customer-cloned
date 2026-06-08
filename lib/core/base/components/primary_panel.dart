import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

class PrimaryPanel extends StatelessWidget {
  const PrimaryPanel({
    super.key,
    required this.child,
    this.padding = AppDimensions.mediumPaddingAll,
    this.margin,
    this.borderRadius = AppDimensions.mediumBorderRadius,
    this.borderColor = const Color(0xFFF0E9E2),
    this.borderWidth = AppDimensions.mediumBorderStroke,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.constraints,
    this.boxShadow,
    this.clipBehavior = Clip.none,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final Color borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final panel = Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      padding: padding,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: boxShadow ?? [PrimaryBoxShadows.defaultShadow],
      ),
      child: child,
    );

    if (onTap == null) return panel;

    return PrimaryAnimatedPressableWidget(
      onTap: onTap,
      child: panel,
    );
  }
}
