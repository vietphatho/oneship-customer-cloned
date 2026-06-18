import 'package:oneship_customer/features/barcode_scanner/domain/entities/barcode_camera_permission_status.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/repositories/barcode_scanner_permission_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerPermissionRepositoryImpl
    implements BarcodeScannerPermissionRepository {
  const BarcodeScannerPermissionRepositoryImpl();

  @override
  Future<BarcodeCameraPermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted || status.isLimited) {
      return BarcodeCameraPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return BarcodeCameraPermissionStatus.permanentlyDenied;
    }
    if (status.isRestricted) {
      return BarcodeCameraPermissionStatus.restricted;
    }
    return BarcodeCameraPermissionStatus.denied;
  }

  @override
  Future<bool> openSettings() {
    return openAppSettings();
  }
}
