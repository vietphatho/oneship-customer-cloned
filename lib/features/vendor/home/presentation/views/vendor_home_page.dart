import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_avatar.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_bloc.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_state.dart';
import 'package:oneship_customer/features/vendor/master/data/vendor_navigation_item.dart';
import 'package:oneship_customer/features/vendor/master/presentation/bloc/vendor_master_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_state.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/withdraw_bottom_sheet.dart';

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
  final VendorStatsBloc _vendorStatsBloc = getIt.get();
  final AuthBloc _authBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _vendorProfileBloc.init();
    if (_hasSecondPassword) {
      _vendorStatsBloc.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
    if (!_hasSecondPassword) {
      return const _PromoBanner();
    }

    return Column(
      children: [
        const _PromoBanner(),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        const _StatsPanel(),
      ],
    );
  }

  bool get _hasSecondPassword =>
      _authBloc.userProfile.hasSecondPassword == true;

  Future<void> _refresh() async {
    if (_hasSecondPassword) {
      await _vendorStatsBloc.refresh();
    }
  }
}
