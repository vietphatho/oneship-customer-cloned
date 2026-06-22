import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
part '../widgets/shop_home_v2_header_section.dart';
part '../widgets/shop_home_v2_overview_section.dart';
part '../widgets/shop_home_v2_orders_section.dart';
part '../widgets/shop_home_v2_promo_stats_section.dart';

class VendorHomePage extends StatelessWidget {
  const VendorHomePage({super.key});

  static const _backgroundColor = AppColors.shopHomeV2Background;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Đơn hàng của tôi'),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        const _SearchBox(),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        const _StatusTabs(),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        const _OrderList(),
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
