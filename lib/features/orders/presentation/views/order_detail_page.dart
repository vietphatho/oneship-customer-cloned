import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/themes/app_box_shadows.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_detail_info_tab_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_detail_products_list_tab_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_detail_transportation_history_tab_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_detail_tab_bar.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tag.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with SingleTickerProviderStateMixin {
  final OrdersBloc _ordersBloc = getIt.get();

  final _tabList = OrderDetailTab.values;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "order_detail".tr()),
      body: BlocConsumer<OrdersBloc, OrdersState>(
        bloc: _ordersBloc,
        listener: _handleListener,
        builder: (context, state) {
          OrderDetailEntity? ordDtl = state.orderDetailResource.data;
          if (ordDtl == null) {
            return const PrimaryEmptyData();
          }

          return DefaultTabController(
            length: _tabList.length,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.smallSpacing,
                  ),
                  child: _Header(ordDtl: ordDtl),
                ),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                OrderDetailTabBar(
                  controller: _tabCtrl,
                  items: _tabList,
                  onTap: _onTabChanged,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: [
                      const OrderDetailInfoTabView(),
                      const OrderDetailProductsListTabView(),
                      OrderDetailTransportationHistoryTabView(
                        trackingCode: ordDtl.trackingCode ?? ordDtl.orderNumber,
                        fallbackStartedAt: ordDtl.createdAt,
                        deliveryLocation: ordDtl.coordinates?.latLong,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleListener(BuildContext context, OrdersState state) {}

  void _onTabChanged(int p1) {}
}

class _Header extends StatelessWidget {
  const _Header({required this.ordDtl});

  final OrderDetailEntity ordDtl;

  @override
  Widget build(BuildContext context) {
    final orderNumber = ordDtl.orderNumber ?? "--";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        boxShadow: AppBoxShadows.card,
        borderRadius: AppDimensions.largeBorderRadius,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.xSmallSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: PrimaryText(
                    orderNumber,
                    style: AppTextStyles.labelMedium,
                  ),
                ),
              ),
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: "copy".tr(),
                onPressed: () => _copyOrderNumber(context, orderNumber),
                icon: Icon(
                  Icons.content_copy,
                  color: AppColors.secondary,
                  size: AppDimensions.xSmallIconSize,
                ),
              ),
            ],
          ),
          PrimaryText(
            DateTimeUtils.formatDateTime(ordDtl.createdAt?.toLocal()),
            style: AppTextStyles.bodyXSmall,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          Row(
            children: [
              OrderStatusTag(status: ordDtl.status ?? "--"),
              const Spacer(),
              if (![
                OrderStatus.delivered.value,
                OrderStatus.returned.value,
                OrderStatus.cancelled.value,
              ].contains(ordDtl.status))
                _EditButton(onPressed: () => _editOrder(context)),
            ],
          ),
        ],
      ),
    );
  }

  void _copyOrderNumber(BuildContext context, String orderNumber) {
    Clipboard.setData(ClipboardData(text: orderNumber));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: EdgeInsets.all(AppDimensions.mediumSpacing),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.mediumBorderRadius,
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              AppSpacing.horizontal(AppDimensions.smallSpacing),
              PrimaryText(
                "order_code_copied".tr(),
                color: Colors.white,
                style: AppTextStyles.labelXSmall,
                bold: true,
              ),
            ],
          ),
        ),
      );
  }

  void _editOrder(BuildContext context) {
    final CreateOrderBloc createOrderBloc = getIt.get();
    final ProductBloc productBloc = getIt.get();
    final ShopBloc shopBloc = getIt.get();
    createOrderBloc.initUpdateOrdData(
      ordDtl,
      shippingServices: shopBloc.state.shippingServices,
    );
    productBloc.initUpdateSelectedProduct(ordDtl.items);
    context.push(RouteName.createOrderPage);
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppDimensions.mediumBorderRadius,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.mediumSpacing,
          vertical: AppDimensions.xxSmallSpacing,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.mediumBorderRadius,
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, size: 14, color: AppColors.primary),
            AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
            PrimaryText(
              "edit".tr(),
              style: AppTextStyles.labelXSmall,
              color: AppColors.primary,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}
