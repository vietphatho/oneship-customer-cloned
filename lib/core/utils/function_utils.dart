import 'package:oneship_customer/di/injection_container.dart';

class FunctionUtils {
  FunctionUtils._();

  //reset all lazySingleton
  static void handleAfterLogout() {
    getIt.resetLazySingletons();
  }
}
