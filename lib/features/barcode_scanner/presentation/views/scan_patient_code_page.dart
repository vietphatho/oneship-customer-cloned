import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/barcode_scanner/barcode_scanner.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class ScanPatientCodePage extends StatefulWidget {
  const ScanPatientCodePage({super.key});

  @override
  State<ScanPatientCodePage> createState() => _ScanPatientCodePageState();
}

class _ScanPatientCodePageState extends State<ScanPatientCodePage> {
  final ShopBloc _shopBloc = getIt.get();
  final BarcodeScannerBloc _barcodeScannerBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _barcodeScannerBloc.startScanning(
      shopId: _shopBloc.state.currentShop?.shopId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral1,
      appBar: PrimaryAppBar(
        title: 'scan_patient_code.title'.tr(),
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
        child: BlocConsumer<BarcodeScannerBloc, BarcodeScannerState>(
          bloc: _barcodeScannerBloc,
          listenWhen: (previous, current) =>
              previous.updateGoogleSheetResource !=
              current.updateGoogleSheetResource,
          listener: _handleScanResultChanged,
          builder: (context, state) {
            return ReusableBarcodeScannerView(
              isProcessing: state.isUpdateRunning,
              instructionText: 'scan_patient_code.instruction'.tr(),
              processingText: 'scan_patient_code.updating'.tr(),
              permissionDeniedText: 'scan_patient_code.camera_permission_error'
                  .tr(),
              openSettingsText: 'open_settings'.tr(),
              retryText: 'retry'.tr(),
              onBarcodeDetected: _handleBarcodeDetected,
              onScannerError: _handleScannerError,
            );
          },
        ),
      ),
    );
  }

  void _handleBarcodeDetected(BarcodeScanResult result) {
    _barcodeScannerBloc.onBarcodeDetected(result.code);
  }

  void _handleScannerError(Object error) {
    if (!mounted) return;
    PrimaryDialog.showErrorDialog(
      context,
      message: 'scan_patient_code.camera_permission_error',
    );
  }

  void _handleScanResultChanged(
    BuildContext context,
    BarcodeScannerState state,
  ) {
    final resource = state.updateGoogleSheetResource;
    if (resource.state == Result.loading) return;

    if (resource.state == Result.success) {
      PrimaryDialog.showSuccessDialog(
        context,
        message: 'scan_patient_code.update_success',
        onClosed: _barcodeScannerBloc.resumeScanning,
      );
      return;
    }

    PrimaryDialog.showErrorDialog(
      context,
      message: resource.message.isEmpty
          ? 'error_code.server_error'
          : resource.message,
      onClosed: _barcodeScannerBloc.resumeScanning,
    );
  }
}
