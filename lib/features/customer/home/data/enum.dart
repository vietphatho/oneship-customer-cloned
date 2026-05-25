import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/customer/home/presentation/views/customer_completed_ords_tab_view.dart';
import 'package:oneship_customer/features/customer/home/presentation/views/customer_in_progress_ords_tab_view.dart';

enum CustomerOrdTab { inProgress, completed }

extension CustomerOrdTabX on CustomerOrdTab {
  static const _mapName = {
    CustomerOrdTab.inProgress: "in_progress_ords",
    CustomerOrdTab.completed: "completed_ords",
  };

  static const _mapView = {
    CustomerOrdTab.inProgress: CustomerInProgressOrdsTabView(),
    CustomerOrdTab.completed: CustomerCompletedOrdsTabView(),
  };

  String get statusName => _mapName[this]!;

  Widget get pageView => _mapView[this]!;
}
