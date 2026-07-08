import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/entities/barcode_scan_result.dart';
import 'package:oneship_customer/features/barcode_scanner/presentation/widgets/reusable_barcode_scanner_view.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class HospitalMedicalRecordScannerPage extends StatefulWidget {
  const HospitalMedicalRecordScannerPage({super.key});

  @override
  State<HospitalMedicalRecordScannerPage> createState() =>
      _HospitalMedicalRecordScannerPageState();
}

class _HospitalMedicalRecordScannerPageState
    extends State<HospitalMedicalRecordScannerPage> {
  final OrdersBloc _ordersBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _ordersBloc.startHospitalMedicalRecordScanning(
      shopId: _shopBloc.state.currentShop?.shopId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral1,
      appBar: PrimaryAppBar(
        title: 'hospital_medical_record_scanner.title'.tr(),
        backgroundColor: AppColors.neutral1,
        titleColor: AppColors.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.onPrimary),
          tooltip: 'close'.tr(),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          listenWhen: (previous, current) =>
              previous.hospitalScannerResource !=
              current.hospitalScannerResource,
          listener: _handleHospitalScannerResourceChanged,
          builder: (context, state) {
            return ReusableBarcodeScannerView(
              isProcessing: _isClosing || state.isHospitalScanRunning,
              instructionText: 'hospital_medical_record_scanner.instruction'
                  .tr(),
              processingText: 'hospital_medical_record_scanner.processing'.tr(),
              permissionDeniedText:
                  'hospital_medical_record_scanner.camera_permission_error'
                      .tr(),
              openSettingsText: 'open_settings'.tr(),
              retryText: 'retry'.tr(),
              formats: const <BarcodeFormat>[],
              onBarcodeDetected: _handleBarcodeDetected,
              onScannerError: _handleScannerError,
            );
          },
        ),
      ),
    );
  }

  void _handleBarcodeDetected(BarcodeScanResult result) {
    _ordersBloc.onHospitalMedicalRecordDetected(result.code);
  }

  void _handleScannerError(Object error) {
    if (!mounted) return;
    PrimaryDialog.showErrorDialog(
      context,
      message: 'hospital_medical_record_scanner.camera_permission_error',
    );
  }

  void _handleHospitalScannerResourceChanged(
    BuildContext context,
    OrdersState state,
  ) {
    final resource = state.hospitalScannerResource;
    if (resource.state == Result.loading) return;

    if (resource.state == Result.success) {
      _showSuccessToast(context);
      return;
    }

    if (resource.state == Result.error) {
      setState(() => _isClosing = true);
      Navigator.of(context).pop<Resource>(resource);
    }
  }

  void _showSuccessToast(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(AppDimensions.mediumSpacing),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.mediumBorderRadius,
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: AppDimensions.mediumIconSize,
              ),
              AppSpacing.horizontal(AppDimensions.smallSpacing),
              Flexible(
                child: PrimaryText(
                  'hospital_medical_record_scanner.scan_success'.tr(),
                  color: Colors.white,
                  style: AppTextStyles.labelXSmall,
                  bold: true,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
