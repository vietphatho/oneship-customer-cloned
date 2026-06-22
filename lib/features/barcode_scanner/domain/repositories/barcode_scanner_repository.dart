import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';

abstract class BarcodeScannerRepository extends BaseRepository {
  Future<Resource> updateGoogleSheet({
    required String medicalRecordCode,
    required String shopId,
  });
}
