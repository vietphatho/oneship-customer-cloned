import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/views/confirmation_info_page_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_info_page_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/pick_up_time_page_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/receiver_info_page_view.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final CreateOrderBloc _createOrderBloc = getIt.get();
  final LocationServiceBloc _locationServiceBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    var shop = _shopBloc.state.currentShop;
    if (shop != null) {
      _createOrderBloc.setShop(shop);
    }
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<CreateOrderBloc>();
    _locationServiceBloc.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      listenWhen:
          (pre, cur) => pre.step != cur.step || pre.request != cur.request,
      listener: _handleListener,
      child: Scaffold(
        appBar: PrimaryAppBar(title: "Create order"),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const PickUpTimePageView(),
            const ReceiverInfoPageView(),
            const OrderInfoPageView(),
            const ConfirmationInfoPageView(),
          ],
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, CreateOrderState state) {
    if (state is CreateOrderRequestChangedState) {
      _pageController.animateToPage(
        state.step.index,
        duration: Constants.pageViewTransitionDur,
        curve: Curves.easeInOut,
      );
    }
  }
}
