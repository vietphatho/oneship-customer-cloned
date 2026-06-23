import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';

class EscPosGenerator {
  static Future<List<int>> generateOrderReceipt(OrderDetailEntity order) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    // Shop Info
    bytes += generator.text(
      order.shop?.shopName ?? 'ONESHIP SHOP',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    if (order.shop?.fullAddress != null && order.shop!.fullAddress.isNotEmpty) {
      bytes += generator.text(order.shop!.fullAddress, styles: const PosStyles(align: PosAlign.center));
    }
    if (order.shop?.phone != null && order.shop!.phone.isNotEmpty) {
      bytes += generator.text('SDT: ${order.shop!.phone}', styles: const PosStyles(align: PosAlign.center));
    }
    
    bytes += generator.hr();
    
    // Order Info
    bytes += generator.text('Ma don: ${order.orderNumber ?? order.id ?? "--"}', styles: const PosStyles(bold: true));
    bytes += generator.text('Ngay tao: ${DateTimeUtils.formatDateTime(order.createdAt?.toLocal() ?? DateTime.now())}');
    bytes += generator.text('Nguoi nhan: ${order.customerName ?? "--"}');
    if (order.phone != null) {
      bytes += generator.text('SDT: ${order.phone}');
    }
    if (order.fullAddress != null) {
      bytes += generator.text('Dia chi: ${order.fullAddress}');
    }

    bytes += generator.hr();
    
    // Items
    bytes += generator.row([
      PosColumn(text: 'Ten SP', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: 'SL', width: 2, styles: const PosStyles(bold: true, align: PosAlign.center)),
      PosColumn(text: 'Tien', width: 4, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    
    for (var item in order.items) {
      bytes += generator.row([
        PosColumn(text: item.productName ?? 'SP', width: 6),
        PosColumn(text: item.quantity.toString(), width: 2, styles: const PosStyles(align: PosAlign.center)),
        PosColumn(text: Utils.formatCurrencyInput(item.unitPrice * item.quantity), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    
    bytes += generator.hr();
    
    // Totals
    bytes += generator.row([
      PosColumn(text: 'Tong tien hang:', width: 7),
      PosColumn(text: Utils.formatCurrencyInput(order.totalProductAmount), width: 5, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Phi giao hang:', width: 7),
      PosColumn(text: Utils.formatCurrencyInput(order.totalDeliveryFee), width: 5, styles: const PosStyles(align: PosAlign.right)),
    ]);
    
    bytes += generator.hr();
    
    bytes += generator.row([
      PosColumn(text: 'TIEN THU HO:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: Utils.formatCurrencyWithUnit(order.collectAmount), width: 6, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    
    bytes += generator.hr(ch: '=');
    if (order.note != null && order.note!.isNotEmpty) {
      bytes += generator.text('Ghi chu: ${order.note}');
      bytes += generator.hr();
    }
    
    bytes += generator.text('Cam on quy khach!', styles: const PosStyles(align: PosAlign.center, bold: true));
    
    bytes += generator.feed(2);
    bytes += generator.cut();
    
    return bytes;
  }
}
