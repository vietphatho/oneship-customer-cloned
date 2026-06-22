import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
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
  static const _shopId = '019eed2d-431c-7f5c-8a69-3d6bc9746dab';
  static const _vendorId = '019eed48-76e7-7584-9f0b-49d30f727403';

  ShopVendorEntity? _vendor;

  @override
  void initState() {
    super.initState();
    _fetchVendor();
  }

  Future<void> _fetchVendor() async {
    final response = await getIt.get<ShopBloc>().fetchShopVendor(
      shopId: _shopId,
      vendorId: _vendorId,
    );
    if (!mounted || response.data == null) return;

    setState(() => _vendor = response.data);
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
        _HomeHeader(vendor: _vendor),
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
