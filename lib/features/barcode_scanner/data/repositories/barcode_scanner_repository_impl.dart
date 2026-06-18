import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/barcode_scanner/data/data_sources/barcode_scanner_api.dart';
import 'package:oneship_customer/features/barcode_scanner/data/models/request/update_google_sheet_request.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/repositories/barcode_scanner_repository.dart';

@LazySingleton(as: BarcodeScannerRepository)
class BarcodeScannerRepositoryImpl extends BarcodeScannerRepository {
  BarcodeScannerRepositoryImpl(this._api);

  final BarcodeScannerApi _api;

  @override
  Future<Resource> updateGoogleSheet({
    required String medicalRecordCode,
    required String shopId,
  }) {
    return request(
      () => _api.updateGoogleSheet(
        UpdateGoogleSheetRequest(
          medicalRecordCode: medicalRecordCode,
          shopId: shopId,
        ),
      ),
    );
  }
}
