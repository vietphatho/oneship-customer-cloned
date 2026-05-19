import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
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
  bool _didSelectInitialTab = false;

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
          _selectInitialTab(ordDtl);

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
                AppSpacing.vertical(AppDimensions.mediumSpacing),
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

  void _selectInitialTab(OrderDetailEntity ordDtl) {
    if (_didSelectInitialTab) return;

    final shouldOpenTransportHistory =
        ordDtl.status == OrderStatus.delivered.value ||
        ordDtl.status == OrderStatus.returned.value;
    if (shouldOpenTransportHistory) {
      _tabCtrl.index = _tabList.indexOf(OrderDetailTab.transHistory);
    }
    _didSelectInitialTab = true;
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key, required this.ordDtl});

  final OrderDetailEntity ordDtl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        boxShadow: AppBoxShadows.card,
        borderRadius: AppDimensions.largeBorderRadius,
      ),
      padding: AppDimensions.smallPaddingAll,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: PrimaryText(
                    ordDtl.orderNumber,
                    style: AppTextStyles.labelLarge,
                  ),
                ),
                PrimaryText(
                  DateTimeUtils.formatDateTime(ordDtl.createdAt),
                  style: AppTextStyles.bodySmall,
                ),
                AppSpacing.vertical(AppDimensions.xSmallSpacing),
                OrderStatusTag(status: ordDtl.status ?? "--"),
              ],
            ),
          ),
          AppSpacing.horizontal(AppDimensions.mediumSpacing),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: Icon(Icons.print, color: AppColors.secondary),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: Icon(Icons.edit_document, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
