import 'package:oneship_customer/features/barcode_scanner/domain/entities/barcode_camera_permission_status.dart';

abstract class BarcodeScannerPermissionRepository {
  Future<BarcodeCameraPermissionStatus> requestCameraPermission();

  Future<bool> openSettings();
}
