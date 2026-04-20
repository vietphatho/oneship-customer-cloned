import 'dart:ui';

import 'package:oneship_customer/core/base/base_import_components.dart';

class LiquidGlassView extends StatelessWidget {
  const LiquidGlassView({
    super.key,
    required this.child,
    this.borderRadius,
    this.isEnable = true,
    this.opacity = 0.65,
    this.blurness = 8.0,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final bool isEnable;

  final double opacity;
  final double blurness;

  @override
  Widget build(BuildContext context) {
    if (!isEnable) return child;

    // if (AppTheme.isDarkMode(context)) {
    //   return ClipRRect(
    //     borderRadius: borderRadius ?? BorderRadius.zero,
    //     child: BackdropFilter(
    //       filter: ImageFilter.blur(
    //         sigmaX: blurness,
    //         sigmaY: blurness,
    //         tileMode: TileMode.mirror,
    //       ),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           // color: Colors.white.valueOpacity(opacity),
    //           borderRadius: borderRadius,
    //           border: Border.all(
    //             color: AppColors.neutral3.valueOpacity(
    //               clampDouble(opacity * 2, 0, 1),
    //             ),
    //             width: 0.5,
    //           ),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.white.valueOpacity(0.15),
    //               blurRadius: 30,
    //               spreadRadius: -10,
    //             ),
    //           ],
    //         ),
    //         child: Stack(
    //           children: [
    //             // ✨ Highlight phản chiếu ánh sáng
    //             Positioned.fill(
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   gradient: LinearGradient(
    //                     begin: Alignment.topLeft,
    //                     end: Alignment.bottomRight,
    //                     colors: [
    //                       Colors.white.valueOpacity(0.3),
    //                       Colors.white.valueOpacity(0.1),
    //                       Colors.transparent,
    //                     ],
    //                     stops: const [0.0, 0.3, 1.0],
    //                   ),
    //                   borderRadius: borderRadius,
    //                 ),
    //               ),
    //             ),
    //             // ✨ Ánh sáng mờ ở đáy
    //             Positioned(
    //               bottom: 0,
    //               left: 0,
    //               right: 0,
    //               height: MediaQuery.of(context).size.height * 0.05,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   gradient: LinearGradient(
    //                     begin: Alignment.bottomCenter,
    //                     end: Alignment.topCenter,
    //                     colors: [
    //                       Colors.white.valueOpacity(0.6),
    //                       Colors.transparent,
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // Positioned(
    //             //   top: 0,
    //             //   left: 0,
    //             //   right: 0,
    //             //   height: 80,
    //             //   child: Container(
    //             //     decoration: BoxDecoration(
    //             //       gradient: LinearGradient(
    //             //         end: Alignment.bottomCenter,
    //             //         begin: Alignment.topCenter,
    //             //         colors: [
    //             //           Colors.white.withOpacity(0.5),
    //             //           Colors.transparent,
    //             //         ],
    //             //       ),
    //             //     ),
    //             //   ),
    //             // ),
    //             child,
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurness,
          sigmaY: blurness,
          tileMode: TileMode.mirror,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withOpacity(clampDouble(opacity * 2, 0, 1)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Stack(
            children: [
              // ✨ Highlight phản chiếu ánh sáng
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                    borderRadius: borderRadius,
                  ),
                ),
              ),
              // ✨ Ánh sáng mờ ở đáy
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   height: 80,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         begin: Alignment.bottomCenter,
              //         end: Alignment.topCenter,
              //         colors: [
              //           Colors.white.withOpacity(0.6),
              //           Colors.transparent,
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   height: 80,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         end: Alignment.bottomCenter,
              //         begin: Alignment.topCenter,
              //         colors: [
              //           Colors.white.withOpacity(0.5),
              //           Colors.transparent,
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
