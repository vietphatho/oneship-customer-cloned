import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/repositories/barcode_scanner_repository.dart';

@lazySingleton
class UpdateGoogleSheetUseCase {
  const UpdateGoogleSheetUseCase(this._repository);

  final BarcodeScannerRepository _repository;

  Future<Resource> call({
    required String medicalRecordCode,
    required String shopId,
  }) {
    return _repository.updateGoogleSheet(
      medicalRecordCode: medicalRecordCode,
      shopId: shopId,
    );
  }
}
