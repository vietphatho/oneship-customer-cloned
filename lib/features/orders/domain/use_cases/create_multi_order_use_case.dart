import 'dart:io';

import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/utils/app_logger.dart';

@lazySingleton
class CreateMultiOrderUseCase {
  CreateMultiOrderUseCase();

  Future<void> call({required String filePath}) async {
    File file = File(filePath);
    // 3. Đọc bytes
    final bytes = file.readAsBytesSync();
    try {
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        // print(table); //sheet Name
        // print(excel.tables[table]?.maxColumns);
        // print(excel.tables[table]?.maxRows);
        for (var row in excel.tables[table]!.rows) {
          for (var cell in row) {
            // print('cell ${cell?.rowIndex}/${cell?.columnIndex}');
            // final value = cell?.value;
            // switch (value) {
            //   case null:
            //     print('  empty cell');
            //   case TextCellValue():
            //     print('  text: ${value.value}');
            //   case FormulaCellValue():
            //     print('  formula: ${value.formula}');
            //   case IntCellValue():
            //     print('  int: ${value.value}');
            //   case BoolCellValue():
            //     print('  bool: ${value.value ? 'YES!!' : 'NO..'}');
            //   case DoubleCellValue():
            //     print('  double: ${value.value}');
            //   case DateCellValue():
            //     print(
            //       '  date: ${value.year} ${value.month} ${value.day} (${value.asDateTimeLocal()})',
            //     );
            //   case TimeCellValue():
            //     print(
            //       '  time: ${value.hour} ${value.minute} ... (${value.asDuration()})',
            //     );
            //   case DateTimeCellValue():
            //     print(
            //       '  date with time: ${value.year} ${value.month} ${value.day} ${value.hour} ... (${value.asDateTimeLocal()})',
            //     );
            // }
          }
        }
      }
    } catch (e) {
      AppLogger().log(e.toString());
    }
  }
}
