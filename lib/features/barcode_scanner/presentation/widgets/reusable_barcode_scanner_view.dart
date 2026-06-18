import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/barcode_scanner/data/repositories/barcode_scanner_permission_repository_impl.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/entities/barcode_camera_permission_status.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/entities/barcode_scan_result.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/use_cases/open_barcode_scanner_settings_use_case.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/use_cases/request_barcode_camera_permission_use_case.dart';

class ReusableBarcodeScannerView extends StatefulWidget {
  const ReusableBarcodeScannerView({
    super.key,
    required this.onBarcodeDetected,
    required this.instructionText,
    required this.processingText,
    required this.permissionDeniedText,
    required this.openSettingsText,
    required this.retryText,
    this.isProcessing = false,
    this.onScannerError,
  });

  final ValueChanged<BarcodeScanResult> onBarcodeDetected;
  final ValueChanged<Object>? onScannerError;
  final String instructionText;
  final String processingText;
  final String permissionDeniedText;
  final String openSettingsText;
  final String retryText;
  final bool isProcessing;

  @override
  State<ReusableBarcodeScannerView> createState() =>
      _ReusableBarcodeScannerViewState();
}

class _ReusableBarcodeScannerViewState extends State<ReusableBarcodeScannerView>
    with WidgetsBindingObserver {
  final RequestBarcodeCameraPermissionUseCase _requestPermissionUseCase =
      const RequestBarcodeCameraPermissionUseCase(
        BarcodeScannerPermissionRepositoryImpl(),
      );
  final OpenBarcodeScannerSettingsUseCase _openSettingsUseCase =
      const OpenBarcodeScannerSettingsUseCase(
        BarcodeScannerPermissionRepositoryImpl(),
      );

  late final MobileScannerController _scannerController;
  BarcodeCameraPermissionStatus? _permissionStatus;
  bool _isControllerStarted = false;

  static const List<BarcodeFormat> _supportedFormats = [
    BarcodeFormat.qrCode,
    BarcodeFormat.codabar,
    BarcodeFormat.code39,
    BarcodeFormat.code93,
    BarcodeFormat.code128,
    BarcodeFormat.ean8,
    BarcodeFormat.ean13,
    BarcodeFormat.itf14,
    BarcodeFormat.upcA,
    BarcodeFormat.upcE,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scannerController = MobileScannerController(
      autoStart: false,
      formats: _supportedFormats,
    );
    _requestPermission();
  }

  @override
  void didUpdateWidget(covariant ReusableBarcodeScannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isProcessing == widget.isProcessing) return;

    if (widget.isProcessing) {
      _stopScanner();
      return;
    }

    _startScanner();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_permissionStatus != BarcodeCameraPermissionStatus.granted) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _startScanner();
        return;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopScanner();
        return;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final permissionStatus = _permissionStatus;
    if (permissionStatus == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeCap: StrokeCap.round,
        ),
      );
    }

    if (permissionStatus != BarcodeCameraPermissionStatus.granted) {
      return _BarcodeScannerPermissionView(
        message: widget.permissionDeniedText,
        openSettingsText: widget.openSettingsText,
        retryText: widget.retryText,
        onOpenSettings: _openSettingsUseCase.call,
        onRetry: _requestPermission,
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcodesDetected,
          ),
        ),
        const Positioned.fill(child: _BarcodeScannerFinderOverlay()),
        Positioned.fill(
          child: _BarcodeScannerInstructionOverlay(
            instructionText: widget.instructionText,
          ),
        ),
        if (widget.isProcessing)
          Positioned.fill(
            child: _BarcodeScannerLoadingOverlay(
              processingText: widget.processingText,
            ),
          ),
      ],
    );
  }

  Future<void> _requestPermission() async {
    final nextStatus = await _requestPermissionUseCase.call();
    if (!mounted) return;

    setState(() => _permissionStatus = nextStatus);

    if (nextStatus == BarcodeCameraPermissionStatus.granted) {
      await _startScanner();
    }
  }

  Future<void> _startScanner() async {
    if (!mounted ||
        widget.isProcessing ||
        _isControllerStarted ||
        _permissionStatus != BarcodeCameraPermissionStatus.granted) {
      return;
    }

    try {
      await _scannerController.start();
      _isControllerStarted = true;
    } catch (error) {
      _isControllerStarted = false;
      widget.onScannerError?.call(error);
    }
  }

  Future<void> _stopScanner() async {
    if (!_isControllerStarted) return;

    try {
      await _scannerController.stop();
    } catch (error) {
      widget.onScannerError?.call(error);
    } finally {
      _isControllerStarted = false;
    }
  }

  void _handleBarcodesDetected(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstWhereOrNull(
      (barcode) => barcode.rawValue?.trim().isNotEmpty ?? false,
    );
    if (barcode == null) return;

    final code = barcode.rawValue?.trim();
    if (code == null || code.isEmpty) return;

    widget.onBarcodeDetected(
      BarcodeScanResult(code: code, format: barcode.format.name),
    );
  }
}

class _BarcodeScannerFinderOverlay extends StatelessWidget {
  const _BarcodeScannerFinderOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final finderWidth =
              (constraints.maxWidth - AppDimensions.xxxLargeSpacing * 2)
                  .clamp(220.0, 340.0)
                  .toDouble();
          final finderHeight = finderWidth / 1.35;

          return Center(
            child: SizedBox(
              width: finderWidth,
              height: finderHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary,
                    width: AppDimensions.xxSmallSpacing,
                  ),
                  borderRadius: AppDimensions.largeBorderRadius,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BarcodeScannerPermissionView extends StatelessWidget {
  const _BarcodeScannerPermissionView({
    required this.message,
    required this.openSettingsText,
    required this.retryText,
    required this.onOpenSettings,
    required this.onRetry,
  });

  final String message;
  final String openSettingsText;
  final String retryText;
  final Future<bool> Function() onOpenSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppDimensions.largePaddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              color: AppColors.primary,
              size: AppDimensions.displayIconSize,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            PrimaryText(
              message,
              style: AppTextStyles.bodyLarge,
              color: AppColors.onPrimary,
              textAlign: TextAlign.center,
            ),
            AppSpacing.vertical(AppDimensions.largeSpacing),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton.outlined(
                    label: retryText,
                    onPressed: onRetry,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: PrimaryButton.filled(
                    label: openSettingsText,
                    onPressed: onOpenSettings,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BarcodeScannerInstructionOverlay extends StatelessWidget {
  const _BarcodeScannerInstructionOverlay({required this.instructionText});

  final String instructionText;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.largeSpacing,
          vertical: AppDimensions.xLargeSpacing,
        ),
        child: Column(
          children: [
            const Spacer(),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.neutral1.withValues(alpha: 0.72),
                borderRadius: AppDimensions.largeBorderRadius,
                border: Border.all(color: AppColors.primaryLight),
              ),
              child: Padding(
                padding: AppDimensions.mediumPaddingAll,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.primary,
                      size: AppDimensions.mediumIconSize,
                    ),
                    AppSpacing.horizontal(AppDimensions.smallSpacing),
                    Flexible(
                      child: PrimaryText(
                        instructionText,
                        style: AppTextStyles.bodyMedium,
                        color: AppColors.onPrimary,
                        maxLine: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
          ],
        ),
      ),
    );
  }
}

class _BarcodeScannerLoadingOverlay extends StatelessWidget {
  const _BarcodeScannerLoadingOverlay({required this.processingText});

  final String processingText;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.neutral1.withValues(alpha: 0.42),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppDimensions.largeBorderRadius,
          ),
          child: Padding(
            padding: AppDimensions.largePaddingAll,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeCap: StrokeCap.round,
                ),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                PrimaryText(
                  processingText,
                  style: AppTextStyles.bodyMedium,
                  color: AppColors.neutral2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
