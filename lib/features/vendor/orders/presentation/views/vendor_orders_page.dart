import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/components/primary_tab_bar.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_bloc.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_state.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';

part '../widgets/vendor_orders_section.dart';

class VendorOrdersPage extends StatefulWidget {
  const VendorOrdersPage({super.key});

  @override
  State<VendorOrdersPage> createState() => _VendorOrdersPageState();
}

class _VendorOrdersPageState extends State<VendorOrdersPage> {
  static const _backgroundColor = AppColors.shopHomeV2Background;

  final VendorOrdersBloc _vendorOrdersBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _vendorOrdersBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: PrimaryAppBar(title: "orders".tr()),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.mediumSpacing,
            AppDimensions.mediumSpacing,
            AppDimensions.mediumSpacing,
            150,
          ),
          child: const _OrdersSection(),
        ),
      ),
    );
  }
}
