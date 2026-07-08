import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/request/process_hospital_scanner_request.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class ProcessHospitalScannerUseCase {
  const ProcessHospitalScannerUseCase(this._repository);

  static const String scanSource = 'scanner_popup';
  static const String scanAction = 'confirm_and_print';

  final OrdersRepository _repository;

  Future<Resource> call({
    required String medicalRecordCode,
    required String shopId,
  }) {
    return _repository.processHospitalScanner(
      ProcessHospitalScannerRequest(
        medicalRecordCode: medicalRecordCode,
        shopId: shopId,
        scanSource: scanSource,
        scanAction: scanAction,
      ),
    );
  }
}
