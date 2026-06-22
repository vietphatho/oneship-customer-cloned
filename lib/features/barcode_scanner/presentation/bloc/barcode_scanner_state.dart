import 'package:oneship_customer/core/base/models/resource.dart';

class BarcodeScannerState {
  const BarcodeScannerState({
    required this.updateGoogleSheetResource,
    this.shopId,
    this.isUpdateRunning = false,
    this.lastScannedCode,
  });

  final Resource updateGoogleSheetResource;
  final String? shopId;
  final bool isUpdateRunning;
  final String? lastScannedCode;

  BarcodeScannerState copyWith({
    Resource? updateGoogleSheetResource,
    String? shopId,
    bool? isUpdateRunning,
    String? lastScannedCode,
  }) {
    return BarcodeScannerState(
      updateGoogleSheetResource:
          updateGoogleSheetResource ?? this.updateGoogleSheetResource,
      shopId: shopId ?? this.shopId,
      isUpdateRunning: isUpdateRunning ?? this.isUpdateRunning,
      lastScannedCode: lastScannedCode ?? this.lastScannedCode,
    );
  }
}
