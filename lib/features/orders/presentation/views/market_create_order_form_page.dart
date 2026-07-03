import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/presentation/views/confirmation_info_page_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/create_order_form_page.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/market_sender_info_section.dart';

class MarketCreateOrderFormPage extends StatelessWidget {
  const MarketCreateOrderFormPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        CreateOrderFormContent(
          leadingSections: [
            const MarketSenderInfoSection(),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
          ],
        ),
        const SizedBox.shrink(),
        const ConfirmationInfoPageView(),
      ],
    );
  }
}
