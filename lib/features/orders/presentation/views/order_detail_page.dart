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
                _Header(ordDtl: ordDtl),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                OrderDetailTabBar(
                  controller: _tabCtrl,
                  items: _tabList,
                  onTap: _onTabChanged,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: _tabList.map((e) => Container()).toList(),
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
