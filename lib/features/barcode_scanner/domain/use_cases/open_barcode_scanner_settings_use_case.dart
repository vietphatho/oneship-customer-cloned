import 'package:oneship_customer/features/barcode_scanner/domain/repositories/barcode_scanner_permission_repository.dart';

class OpenBarcodeScannerSettingsUseCase {
  const OpenBarcodeScannerSettingsUseCase(this._repository);

  final BarcodeScannerPermissionRepository _repository;

  Future<bool> call() {
    return _repository.openSettings();
  }
}
