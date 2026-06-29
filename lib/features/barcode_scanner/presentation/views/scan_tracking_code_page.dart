import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/features/barcode_scanner/barcode_scanner.dart';

class ScanTrackingCodePage extends StatefulWidget {
  const ScanTrackingCodePage({super.key});

  @override
  State<ScanTrackingCodePage> createState() => _ScanTrackingCodePageState();
}

class _ScanTrackingCodePageState extends State<ScanTrackingCodePage> {
  bool _isClosing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral1,
      appBar: PrimaryAppBar(
        title: 'scan_tracking_code.title'.tr(),
        backgroundColor: AppColors.neutral1,
        titleColor: AppColors.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.onPrimary),
          tooltip: 'close'.tr(),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ReusableBarcodeScannerView(
          isProcessing: _isClosing,
          instructionText: 'scan_tracking_code.instruction'.tr(),
          processingText: 'loading'.tr(),
          permissionDeniedText: 'scan_tracking_code.camera_permission_error'
              .tr(),
          openSettingsText: 'open_settings'.tr(),
          retryText: 'retry'.tr(),
          onBarcodeDetected: _handleBarcodeDetected,
          onScannerError: _handleScannerError,
        ),
      ),
    );
  }

  void _handleBarcodeDetected(BarcodeScanResult result) {
    if (_isClosing) return;

    setState(() => _isClosing = true);
    context.pop(result.code);
  }

  void _handleScannerError(Object error) {
    if (!mounted) return;
    PrimaryDialog.showErrorDialog(
      context,
      message: 'scan_tracking_code.camera_permission_error',
    );
  }
}
