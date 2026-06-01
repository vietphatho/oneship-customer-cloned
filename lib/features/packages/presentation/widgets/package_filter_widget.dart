import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/packages/enum.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';

class PackageFilterWidget extends StatefulWidget {
  const PackageFilterWidget({super.key});

  @override
  State<PackageFilterWidget> createState() => _PackageFilterWidgetState();
}

class _PackageFilterWidgetState extends State<PackageFilterWidget> {
  final TextEditingController _packageNumberCtrl = TextEditingController();
  final TextEditingController _shipperCodeCtrl = TextEditingController();
  final TextEditingController _statusCtrl = TextEditingController();
  PackageStatus _status = PackageStatus.all;

  final PackagesBloc _packageBloc = getIt.get();

  @override
  void initState() {
    _packageNumberCtrl.text = _packageBloc.state.packageNumber ?? "";
    _shipperCodeCtrl.text = _packageBloc.state.shipperCode ?? "";
    _statusCtrl.text = _packageBloc.state.status.name;
    _status = _packageBloc.state.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryTextField(
          label: "package_number".tr(),
          controller: _packageNumberCtrl,
          hintText: "input".tr(),
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        PrimaryTextField(
          label: "shipper_code".tr(),
          controller: _shipperCodeCtrl,
          hintText: "input".tr(),
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        PrimaryDropdown<PackageStatus>(
          label: "status".tr(),
          controller: _statusCtrl,
          menu: PackageStatus.values,
          initialValue: _status,
          toLabel: (item) => item.name.tr(),
          requestFocusOnTap: false,
          onSelected: (value) => _status = value ?? _status,
        ),
        AppSpacing.vertical(AppDimensions.largeSpacing),
        Row(
          children: [
            Expanded(
              child: SecondaryButton.outlined(
                label: "cancel".tr(),
                onPressed: () => context.pop(),
              ),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            Expanded(
              child: SecondaryButton.filled(
                label: "filter_results".tr(),
                onPressed: _filterPackage,
              ),
            ),
          ],
        ),
        AppSpacing.vertical(AppDimensions.largeSpacing),
        PrimaryAnimatedPressableWidget(
          child: PrimaryText(
            "clear_filter".tr(),
            decoration: TextDecoration.underline,
            style: AppTextStyles.bodyLarge,
            color: AppColors.neutral4,
          ),
          onTap: () {
            _packageNumberCtrl.clear();
            _shipperCodeCtrl.clear();
            _status = PackageStatus.all;
            _statusCtrl.text = _status.name.tr();
          },
        ),
      ],
    );
  }

  void _filterPackage() {
    _packageBloc.filterResults(
      packageNumber: _packageNumberCtrl.text.trim().isEmpty
          ? null
          : _packageNumberCtrl.text.trim(),
      shipperCode: _shipperCodeCtrl.text.trim().isEmpty
          ? null
          : _shipperCodeCtrl.text.trim(),
      status: _status,
    );
    context.pop();
  }
}
