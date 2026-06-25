import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/themes/app_box_shadows.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_detail_info_tab_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_detail_products_list_tab_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_detail_transportation_history_tab_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_detail_tab_bar.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tag.dart';

class VendorOrderDetailPage extends StatefulWidget {
  const VendorOrderDetailPage({super.key});

  @override
  State<VendorOrderDetailPage> createState() => _VendorOrderDetailPageState();
}

class _VendorOrderDetailPageState extends State<VendorOrderDetailPage>
    with SingleTickerProviderStateMixin {
  final OrdersBloc _ordersBloc = getIt.get();

  final _tabList = OrderDetailTab.values;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: 'order_detail'.tr()),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        bloc: _ordersBloc,
        buildWhen: (previous, current) =>
            previous.orderDetailResource != current.orderDetailResource,
        builder: (context, state) {
          final orderDetail = state.orderDetailResource.data;
          if (orderDetail == null) {
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
                  child: _VendorOrderDetailHeader(orderDetail: orderDetail),
                ),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                OrderDetailTabBar(
                  controller: _tabController,
                  items: _tabList,
                  onTap: _onTabChanged,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      const OrderDetailInfoTabView(),
                      const OrderDetailProductsListTabView(),
                      OrderDetailTransportationHistoryTabView(
                        trackingCode:
                            orderDetail.trackingCode ?? orderDetail.orderNumber,
                        fallbackStartedAt: orderDetail.createdAt,
                        deliveryLocation: orderDetail.coordinates?.latLong,
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

  void _onTabChanged(int index) {}
}

class _VendorOrderDetailHeader extends StatelessWidget {
  const _VendorOrderDetailHeader({required this.orderDetail});

  final OrderDetailEntity orderDetail;

  @override
  Widget build(BuildContext context) {
    final orderNumber = orderDetail.orderNumber ?? '--';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        boxShadow: AppBoxShadows.card,
        borderRadius: AppDimensions.largeBorderRadius,
      ),
      padding: AppDimensions.smallPaddingAll,
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
                    style: AppTextStyles.labelLarge,
                  ),
                ),
              ),
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'copy'.tr(),
                onPressed: () => _copyOrderNumber(context, orderNumber),
                icon: const Icon(
                  Icons.content_copy,
                  color: AppColors.secondary,
                  size: 22,
                ),
              ),
            ],
          ),
          PrimaryText(
            DateTimeUtils.formatDateTime(orderDetail.createdAt?.toLocal()),
            style: AppTextStyles.bodySmall,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          OrderStatusTag(status: orderDetail.status ?? '--'),
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
          margin: const EdgeInsets.all(AppDimensions.mediumSpacing),
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
                'order_code_copied'.tr(),
                color: Colors.white,
                style: AppTextStyles.labelXSmall,
                bold: true,
              ),
            ],
          ),
        ),
      );
  }
}
