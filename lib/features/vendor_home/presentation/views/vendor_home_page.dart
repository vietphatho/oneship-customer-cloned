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
import 'package:oneship_customer/features/vendor_home/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor_home/presentation/bloc/vendor_home_bloc.dart';
import 'package:oneship_customer/features/vendor_home/presentation/bloc/vendor_home_order_tab.dart';
import 'package:oneship_customer/features/vendor_home/presentation/bloc/vendor_home_state.dart';
part '../widgets/shop_home_v2_header_section.dart';
part '../widgets/shop_home_v2_overview_section.dart';
part '../widgets/shop_home_v2_orders_section.dart';
part '../widgets/shop_home_v2_promo_stats_section.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({super.key});

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  static const _backgroundColor = AppColors.shopHomeV2Background;

  final VendorHomeBloc _vendorHomeBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _vendorHomeBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              AppSpacing.vertical(AppDimensions.largeSpacing),
              _buildOrdersSection(),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              _buildPromoStatsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        const _HomeHeader(),
        AppSpacing.vertical(4),
        const _TopCards(),
        AppSpacing.vertical(8),
        const _QuickActions(),
      ],
    );
  }

  Widget _buildOrdersSection() {
    return const _OrdersSection();
  }

  Widget _buildPromoStatsSection() {
    return Column(
      children: [
        const _PromoBanner(),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        const _StatsPanel(),
      ],
    );
  }
}
