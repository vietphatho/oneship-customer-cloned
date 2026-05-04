import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/app_logger.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart';

class CreateMultiOrdersPage extends StatefulWidget {
  const CreateMultiOrdersPage({super.key});

  @override
  State<CreateMultiOrdersPage> createState() => _CreateMultiOrdersPageState();
}

class _CreateMultiOrdersPageState extends State<CreateMultiOrdersPage> {
  final ShopBloc _shopBloc = getIt.get();

  String? _filePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "create_multi_orders".tr()),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText("shop_name".tr(), style: AppTextStyles.titleLarge),
              BlocListener<ShopBloc, ShopState>(
                bloc: _shopBloc,
                listenWhen:
                    (pre, cur) =>
                        pre.dailySummaryResource != cur.dailySummaryResource,
                listener: _handleListenerChangedShop,
                child: PrimaryDropdown<ShopEntity>(
                  initialValue: _shopBloc.state.currentShop,
                  toLabel: (item) {
                    return item.shopName;
                  },
                  menu: _shopBloc.state.shopsResource.data!.data,
                  onSelected: (value) {
                    if (value != _shopBloc.state.currentShop) {
                      _shopBloc.changeShop(value!);
                    }
                  },
                ),
              ),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              PrimaryText(
                "order_information".tr(),
                style: AppTextStyles.titleLarge,
              ),
              _ExcelViewerWidget(filePath: _filePath),
              AppSpacing.vertical(AppDimensions.largeSpacing),
              SecondaryButton.outlined(
                label: 'imported_from_excel'.tr(),
                onPressed: () {
                  _pickExcelFile();
                },
              ),
              AppSpacing.vertical(AppDimensions.largeSpacing),
              if (_filePath != null)
                SecondaryButton.filled(
                  label: 'create_order'.tr(),
                  onPressed: () {
                    if (_filePath != null) {
                      _decodeExcelFile(_filePath!);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleListenerChangedShop(context, state) {
    switch (state.dailySummaryResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(context);
        break;
    }
  }

  Future<void> _pickExcelFile() async {
    picker.FilePickerResult? result = await picker.FilePicker.pickFiles(
      type: picker.FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
  }

  Future<void> _decodeExcelFile(String filePath) async {
    File file = File(filePath);
    // 3. Đọc bytes
    final bytes = file.readAsBytesSync();

    // 4. Decode Excel
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
      PrimaryDialog.showErrorDialog(context, message: 'excel_file_error'.tr());
    }
  }
}

class _ExcelViewerWidget extends StatelessWidget {
  final String? filePath;
  const _ExcelViewerWidget({this.filePath});

  @override
  Widget build(BuildContext context) {
    return filePath != null
        ? Expanded(child: UniversalFileViewer(file: File(filePath!)))
        : Expanded(
          child: Center(
            child: PrimaryText('no_data'.tr(), style: AppTextStyles.bodyLarge),
          ),
        );
  }
}
