import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/features/order_tracking/presentation/utils/order_tracking_text_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class OrderTrackingScanSuffixButton extends StatefulWidget {
  const OrderTrackingScanSuffixButton({super.key, required this.onScanned});

  final ValueChanged<String> onScanned;

  @override
  State<OrderTrackingScanSuffixButton> createState() =>
      _OrderTrackingScanSuffixButtonState();
}

class _OrderTrackingScanSuffixButtonState
    extends State<OrderTrackingScanSuffixButton> {
  final OrderTrackingTextScanner _textScanner = OrderTrackingTextScanner();
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isScanning ? null : _scanText,
      icon: SvgPicture.asset(
        ImagePath.iconCamera,
        width: AppDimensions.mediumIconSize,
        height: AppDimensions.mediumIconSize,
      ),
    );
  }

  Future<void> _scanText() async {
    setState(() {
      _isScanning = true;
    });
    try {
      final scannedText = await _textScanner.scanFromCamera();
      if (!mounted || scannedText == null || scannedText.isEmpty) {
        return;
      }

      await _showScannedText(scannedText);
    } on PlatformException catch (error) {
      if (!_isPermissionDenied(error)) {
        rethrow;
      }
      if (mounted) {
        _showCameraPermissionDialog();
      }
    } catch (_) {
      if (mounted) {
        PrimaryDialog.showErrorDialog(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _showScannedText(String scannedText) {
    final lines =
        scannedText
            .split(RegExp(r'\r?\n'))
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryText(
                    'scanned_content'.tr(),
                    style: AppTextStyles.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: lines.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final line = lines[index];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: PrimaryText(line),
                          onTap: () {
                            widget.onScanned(line);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _showCameraPermissionDialog() {
    return PrimaryDialog.showQuestionDialog<void>(
      context,
      title: 'notification',
      message: 'camera_permission_required'.tr(),
      positiveButtonText: 'open_settings',
      onPositiveTapped: openAppSettings,
    );
  }

  bool _isPermissionDenied(PlatformException error) {
    return error.code == 'camera_access_denied' ||
        error.code == 'camera_access_restricted';
  }
}
