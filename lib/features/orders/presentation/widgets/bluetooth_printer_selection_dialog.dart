import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/services/bluetooth_print_service.dart';

class BluetoothPrinterSelectionDialog extends StatefulWidget {
  const BluetoothPrinterSelectionDialog({
    super.key,
    required this.onPrinterConnected,
  });

  final VoidCallback onPrinterConnected;

  static void show(BuildContext context, {required VoidCallback onPrinterConnected}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BluetoothPrinterSelectionDialog(onPrinterConnected: onPrinterConnected),
    );
  }

  @override
  State<BluetoothPrinterSelectionDialog> createState() =>
      _BluetoothPrinterSelectionDialogState();
}

class _BluetoothPrinterSelectionDialogState
    extends State<BluetoothPrinterSelectionDialog> {
  final BluetoothPrintService _printService = BluetoothPrintService.instance;
  List<BluetoothDevice> _devices = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    setState(() => _isLoading = true);
    final hasPermission = await _printService.checkAndRequestPermissions();
    if (hasPermission) {
      final devices = await _printService.getPairedDevices();
      setState(() {
        _devices = devices;
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _connectToPrinter(BluetoothDevice device) async {
    PrimaryDialog.showLoadingDialog(context);
    final success = await _printService.connect(device);
    if (mounted) PrimaryDialog.hideLoadingDialog(context);

    if (success) {
      if (mounted) Navigator.pop(context);
      widget.onPrinterConnected();
    } else {
      if (mounted) {
        PrimaryDialog.showErrorDialog(context, message: 'Could not connect to printer');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.mediumSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrimaryText(
                'Select Bluetooth Printer',
                style: AppTextStyles.titleMedium,
              ),
              IconButton(
                onPressed: _initBluetooth,
                icon: const Icon(CupertinoIcons.refresh),
              ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _devices.isEmpty
                    ? const Center(child: PrimaryText('No paired printers found'))
                    : ListView.separated(
                        itemCount: _devices.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final device = _devices[index];
                          return ListTile(
                            leading: const Icon(CupertinoIcons.printer),
                            title: PrimaryText(device.name ?? 'Unknown'),
                            subtitle: PrimaryText(device.address ?? ''),
                            onTap: () => _connectToPrinter(device),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
