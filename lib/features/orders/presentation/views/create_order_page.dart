import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/views/create_order_form_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

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
      _createOrderBloc.syncVisibleSurcharges();
    }
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<CreateOrderBloc>();
    getIt.resetLazySingleton<ProductBloc>();
    _locationServiceBloc.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateOrderBloc, CreateOrderState>(
          bloc: _createOrderBloc,
          listenWhen: (pre, cur) =>
              pre.step != cur.step || pre.errorMessage != cur.errorMessage,
          listener: _handleListener,
        ),
        BlocListener<ShopBloc, ShopState>(
          bloc: _shopBloc,
          listenWhen: (pre, cur) =>
              pre.visibleSurchargeGroupsResource !=
              cur.visibleSurchargeGroupsResource,
          listener: (context, state) =>
              _createOrderBloc.syncVisibleSurcharges(),
        ),
      ],
      child: BlocBuilder<CreateOrderBloc, CreateOrderState>(
        bloc: _createOrderBloc,
        buildWhen: (pre, cur) => pre.updateOrdId != cur.updateOrdId,
        builder: (context, state) {
          final isUpdate = state.updateOrdId != null;
          return Scaffold(
            appBar: PrimaryAppBar(
              title: isUpdate
                  ? "update_order_title".tr()
                  : "create_order_title".tr(),
              confirmPop: true,
            ),
            // Previous create-order page is kept here for quick rollback.
            // body: PageView(
            //   controller: _pageController,
            //   physics: const NeverScrollableScrollPhysics(),
            //   children: [
            //     const ReceiverInfoPageView(),
            //     const OrderInfoPageView(),
            //     const ConfirmationInfoPageView(),
            //   ],
            // ),
            body: CreateOrderFormPage(pageController: _pageController),
          );
        },
      ),
    );
  }

  void _handleListener(BuildContext context, CreateOrderState state) {
    _pageController.animateToPage(
      state.step == CreateOrderStep.confirmation ? state.step.index : 0,
      duration: Constants.pageViewTransitionDur,
      curve: Curves.easeInOut,
    );

    if (state.errorMessage != null) {
      PrimaryDialog.showErrorDialog(context, message: state.errorMessage);
    }
  }
}
