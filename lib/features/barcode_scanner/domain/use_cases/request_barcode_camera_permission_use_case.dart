import 'package:oneship_customer/features/barcode_scanner/domain/entities/barcode_camera_permission_status.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/repositories/barcode_scanner_permission_repository.dart';

class RequestBarcodeCameraPermissionUseCase {
  const RequestBarcodeCameraPermissionUseCase(this._repository);

  final BarcodeScannerPermissionRepository _repository;

  Future<BarcodeCameraPermissionStatus> call() {
    return _repository.requestCameraPermission();
  }
}
