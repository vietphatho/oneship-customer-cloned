import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_home_post_list_page.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShopHomePostListPage(
      title: 'shop_home.news'.tr(),
      category: MobilePostCategory.news,
    );
  }
}
