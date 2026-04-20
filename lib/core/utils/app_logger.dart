import 'dart:developer' as developer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum LogLevel { info, warning, error }

class AppLogger {
  static final AppLogger _i = AppLogger._();
  factory AppLogger() => _i;
  AppLogger._();

  Future<void> _writeQueue = Future.value();

  String _logFileNameByDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return 'app_log_$y-$m-$d.txt';
  }

  Future<File> _getTodayLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = _logFileNameByDate(DateTime.now());
    return File('${dir.path}/$fileName');
  }

  Future<void> log(
    String msg, {
    LogLevel level = LogLevel.info,
    dynamic detail,
  }) async {
    final file = await _getTodayLogFile();
    final time = DateTime.now().toIso8601String();
    final lv = level.name.toUpperCase();

    developer.log(
      '[$time][$lv] $msg ${detail != null ? ": ${detail.toString()}" : ""}',
    );
    _writeQueue = _writeQueue.then((_) {
      file.writeAsString(
        '[$time][$lv] $msg ${detail != null ? ": ${detail.toString()}" : ""}\n',
        mode: FileMode.append,
      );
    });
    await _writeQueue;
  }

  // Future<void> shareTodayLog() async {
  //   await shareLogByDate(DateTime.now());
  // }

  // Future<void> shareLogByDate(DateTime date) async {
  //   try {
  //     final dir = await getApplicationDocumentsDirectory();
  //     final file = File('${dir.path}/${_logFileNameByDate(date)}');

  //     if (!await file.exists()) return;

  //     await Share.shareXFiles(
  //       [XFile(file.path)],
  //       subject:
  //           'Log ngày ${DateFormat(Constant.defaultDateFormat).format(date)}',
  //     );
  //   } catch (e) {
  //     // ignore errors
  //   }
  // }

  // Future<void> shareAllLogs() async {
  //   final dir = await getApplicationDocumentsDirectory();

  //   final files =
  //       dir
  //           .listSync()
  //           .whereType<File>()
  //           .where((f) => f.path.contains('app_log_'))
  //           .map((f) => XFile(f.path))
  //           .toList();

  //   if (files.isEmpty) return;

  //   await Share.shareXFiles(files, subject: 'Tất cả logs');
  // }

  Future<void> cleanOldLogs({int keepDays = 7}) async {
    final dir = await getApplicationDocumentsDirectory();
    final now = DateTime.now();

    for (final e in dir.listSync()) {
      if (e is! File) continue;
      if (!e.path.contains('app_log_')) continue;

      final dateStr = RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(e.path)?.group(0);

      if (dateStr == null) continue;

      final date = DateTime.parse(dateStr);
      if (now.difference(date).inDays > keepDays) {
        await e.delete();
      }
    }
  }
}
