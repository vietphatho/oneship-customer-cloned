import 'dart:io';

import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_multi_orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_multi_orders_state.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<CreateMultiOrdersBloc>();
    super.dispose();
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
              _ExcelViewerWidget(),
              AppSpacing.vertical(AppDimensions.largeSpacing),
              _CreateMultiOrderActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleListenerChangedShop(BuildContext context, ShopState state) {
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
}

class _CreateMultiOrderActionButtons extends StatelessWidget {
  _CreateMultiOrderActionButtons();

  final CreateMultiOrdersBloc _createMultiOrdersBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateMultiOrdersBloc, CreateMultiOrdersState>(
      bloc: _createMultiOrdersBloc,
      builder: (context, state) {
        return Column(
          children: [
            SecondaryButton.outlined(
              label: 'imported_from_excel'.tr(),
              onPressed: () {
                _pickExcelFile();
              },
            ),
            AppSpacing.vertical(AppDimensions.largeSpacing),
            if (_createMultiOrdersBloc.state.filePath.isNotEmpty)
              SecondaryButton.filled(
                label: 'create_order'.tr(),
                onPressed: () {
                  _createMultiOrdersBloc.createdMultiOrder();
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> _pickExcelFile() async {
    picker.FilePickerResult? result = await picker.FilePicker.pickFiles(
      type: picker.FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      _createMultiOrdersBloc.pickedExcelFile(
        filePath: result.files.single.path!,
      );
    }
  }
}

class _ExcelViewerWidget extends StatelessWidget {
  _ExcelViewerWidget();
  final CreateMultiOrdersBloc _createMultiOrdersBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateMultiOrdersBloc, CreateMultiOrdersState>(
      bloc: _createMultiOrdersBloc,
      buildWhen: (previous, current) => previous.filePath != current.filePath,
      builder: (context, state) {
        final filePath = _createMultiOrdersBloc.state.filePath;
        return filePath.isNotEmpty
            ? Expanded(child: UniversalFileViewer(file: File(filePath)))
            : Expanded(child: Center(child: PrimaryEmptyData()));
      },
    );
  }
}
