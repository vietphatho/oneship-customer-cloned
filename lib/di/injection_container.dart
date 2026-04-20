import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/di/injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.init();
  await getIt.allReady();
}
