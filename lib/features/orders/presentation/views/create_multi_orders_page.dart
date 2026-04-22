import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/management/presentation/bloc/management_bloc.dart';

class CreateMultiOrdersPage extends StatefulWidget {
  const CreateMultiOrdersPage({super.key});

  @override
  State<CreateMultiOrdersPage> createState() => _CreateMultiOrdersPageState();
}

class _CreateMultiOrdersPageState extends State<CreateMultiOrdersPage> {
  final ManagementBloc _managementBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "create_multi_orders".tr()),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.mediumSpacing,
          vertical: AppDimensions.mediumSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              "${"shop".tr()}: ${_managementBloc.currentShop?.shopName}",
            ),
            AppSpacing.vertical(AppDimensions.largeSpacing),
            Center(child: _AddDataFileWidget()),
          ],
        ),
      ),
    );
  }
}

class _AddDataFileWidget extends StatelessWidget {
  const _AddDataFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.add_chart_rounded,
          size: AppDimensions.displayIconSize,
          color: AppColors.accentColor1,
        ),
        PrimaryText("add_file".tr()),
      ],
    );
  }
}
