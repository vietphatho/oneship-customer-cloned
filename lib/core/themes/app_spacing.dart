import 'package:flutter/cupertino.dart';

class AppSpacing extends StatelessWidget {
  const AppSpacing({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }

  factory AppSpacing.vertical(double height) => AppSpacing(height: height);

  factory AppSpacing.horizontal(double width) => AppSpacing(width: width);
}
