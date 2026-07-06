import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeviceIdService {
  static const String _androidDeviceIdKey = "id";
  static const String _iosDeviceIdKey = "identifierForVendor";

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    final deviceInfo = await _deviceInfoPlugin.deviceInfo;

    if (Platform.isAndroid) {
      return deviceInfo.data[_androidDeviceIdKey] ?? "";
    }

    return deviceInfo.data[_iosDeviceIdKey] ?? "";
  }
}
