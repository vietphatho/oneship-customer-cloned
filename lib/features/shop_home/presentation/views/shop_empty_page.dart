import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_empty_state.dart';

class ShopEmptyPage extends StatelessWidget {
  const ShopEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ShopEmptyState(
          onCreateShopPressed: () => context.push(RouteName.createShopPage),
        ),
      ),
    );
  }
}
