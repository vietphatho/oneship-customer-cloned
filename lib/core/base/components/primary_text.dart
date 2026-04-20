
import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class PrimaryText extends StatelessWidget {
  final String? text;
  final bool bold;
  final Color? color;
  final double? size;
  final bool onLiquidGlass;

  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLine;
  final TextStyle? style;

  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final List<Shadow>? shadows;

  const PrimaryText(this.text, {
    super.key,
    this.bold = false,
    this.color,
    this.size,
    this.fontWeight,
    this.textAlign,
    this.fontStyle,
    this.maxLine,
    this.overflow,
    this.style,
    this.decoration,
    this.shadows,
    this.onLiquidGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textScaler: TextScaler.noScaling,
      text == null || text.toString() == "" ? "" : text.toString(),
      maxLines: maxLine,
      overflow: overflow,
      textAlign: textAlign,
      style: (style ?? AppTextStyles.defaultTextStyle).copyWith(
        decoration: decoration,
        decorationColor: color,
        decorationThickness: 0.5,
        color: color,
        fontSize: size,
        fontStyle: fontStyle,
        fontWeight: bold ? FontWeight.bold : fontWeight,
        fontFamily: AppTextStyles.fontFamily,
        // shadows:
        //     onLiquidGlass
        //         ? [
        //           const Shadow(color: AppColors.neutral9, blurRadius: 24),
        //           const Shadow(color: Colors.white, blurRadius: 40),
        //         ]
        //         : shadows,
      ),
    );
  }
}
