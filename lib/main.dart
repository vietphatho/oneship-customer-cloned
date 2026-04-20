import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/views/one_ship_customer_app.dart';
import 'package:oneship_customer/core/utils/app_logger.dart';
import 'package:oneship_customer/di/injection_container.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Future.wait([
      EasyLocalization.ensureInitialized(),
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
      // _loadEnvVariable(),
      configureDependencies(),
      AppLogger().cleanOldLogs(),
    ]);

    PlatformDispatcher.instance.onError = (error, stack) {
      catchUnhandledExceptions(error, stack);
      return true;
    };

    FlutterError.onError = (FlutterErrorDetails details) {
      catchUnhandledExceptions(details.exception, details.stack);
    };

    runApp(const OneShipCustomerApp());
  }, catchUnhandledExceptions);
}

void catchUnhandledExceptions(Object error, StackTrace? stack) {
  // logger.e(stackTrace: stack, error.toString());
}

// Future<void> _loadEnvVariable() async {
//   const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
//   await dotenv.load(fileName: ".env.${flavor.toLowerCase()}");
// }

