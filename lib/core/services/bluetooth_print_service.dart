import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:typed_data';

class BluetoothPrintService {
  BluetoothPrintService._();

  static final BluetoothPrintService instance = BluetoothPrintService._();

  final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;

  Future<bool> checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      final statusScan = await Permission.bluetoothScan.request();
      final statusConnect = await Permission.bluetoothConnect.request();
      if (!statusScan.isGranted || !statusConnect.isGranted) {
        return false;
      }
    }
    return true;
  }

  Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      return await _bluetooth.getBondedDevices();
    } catch (e) {
      return [];
    }
  }

  Future<bool> connect(BluetoothDevice device) async {
    try {
      final isConnected = await _bluetooth.isConnected;
      if (isConnected == true) {
        await _bluetooth.disconnect();
      }
      final bool? isConn = await _bluetooth.connect(device);
      return isConn ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      await _bluetooth.disconnect();
    } catch (e) {
      // Ignore
    }
  }

  Future<void> printBytes(List<int> bytes) async {
    try {
      final isConnected = await _bluetooth.isConnected;
      if (isConnected == true) {
        await _bluetooth.writeBytes(Uint8List.fromList(bytes));
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<bool> get isConnected async {
    final bool? result = await _bluetooth.isConnected;
    return result ?? false;
  }
}
