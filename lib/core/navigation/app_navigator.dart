import 'package:flutter/material.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> globalKey =
      GlobalKey<NavigatorState>();

  static BuildContext get globalContext => globalKey.currentContext!;
}
