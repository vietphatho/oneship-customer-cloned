import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_state.dart';

part '../widgets/shop_home_v2_header_section.dart';
part '../widgets/shop_home_v2_overview_section.dart';
part '../widgets/shop_home_v2_promo_stats_section.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({super.key});

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  static const _backgroundColor = AppColors.shopHomeV2Background;

  final VendorProfileBloc _vendorProfileBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _vendorProfileBloc.init();
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
