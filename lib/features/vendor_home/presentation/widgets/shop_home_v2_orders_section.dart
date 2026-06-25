part of '../views/vendor_home_page.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return PrimaryText(title.tr(), style: AppTextStyles.titleMedium);
  }
}

class _OrdersSection extends StatefulWidget {
  const _OrdersSection();

  @override
  State<_OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<_OrdersSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('vendor_home.orders.title'),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        _OrdersTabBar(controller: _tabController),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        IndexedStack(
          index: _tabController.index,
          children: const [
            _OrdersTabBody(tab: VendorHomeOrderTab.processing),
            _OrdersTabBody(tab: VendorHomeOrderTab.archived),
          ],
        ),
      ],
    );
  }
}

class _OrdersTabBar extends StatelessWidget {
  const _OrdersTabBar({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return PrimaryTabBar(
      controller: controller,
      height: AppDimensions.mediumHeightButton,
      borderRadius: AppDimensions.largeBorderRadius,
      items: [
        'vendor_home.orders.processing_tab'.tr(),
        'vendor_home.orders.archived_tab'.tr(),
      ],
    );
  }
}

class _OrdersTabBody extends StatelessWidget {
  const _OrdersTabBody({required this.tab});

  final VendorHomeOrderTab tab;

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<VendorHomeBloc>();

    return BlocBuilder<VendorHomeBloc, VendorHomeState>(
      bloc: bloc,
      buildWhen: (previous, current) {
        return switch (tab) {
          VendorHomeOrderTab.processing =>
            previous.processingOrdersResource !=
                    current.processingOrdersResource ||
                previous.processingKeyword != current.processingKeyword,
          VendorHomeOrderTab.archived =>
            previous.archivedOrdersResource != current.archivedOrdersResource ||
                previous.archivedKeyword != current.archivedKeyword,
        };
      },
      builder: (context, state) {
        final keyword = switch (tab) {
          VendorHomeOrderTab.processing => state.processingKeyword,
          VendorHomeOrderTab.archived => state.archivedKeyword,
        };

        return Column(
          children: [
            _OrderSearchBox(
              keyword: keyword,
              onChanged: (value) => switch (tab) {
                VendorHomeOrderTab.processing => bloc.searchProcessingOrders(
                  value,
                ),
                VendorHomeOrderTab.archived => bloc.searchArchivedOrders(value),
              },
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            _OrderList(tab: tab, state: state),
          ],
        );
      },
    );
  }
}

class _OrderSearchBox extends StatefulWidget {
  const _OrderSearchBox({required this.keyword, required this.onChanged});

  final String keyword;
  final ValueChanged<String> onChanged;

  @override
  State<_OrderSearchBox> createState() => _OrderSearchBoxState();
}

class _OrderSearchBoxState extends State<_OrderSearchBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.keyword);
  }

  @override
  void didUpdateWidget(covariant _OrderSearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyword != _controller.text) {
      _controller.text = widget.keyword;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: _controller,
      hintText: 'vendor_home.orders.search_hint'.tr(),
      textInputAction: TextInputAction.search,
      fillColor: Colors.white,
      suffixIcon: const Icon(
        Icons.search_rounded,
        color: AppColors.neutral1,
        size: AppDimensions.mediumIconSize,
      ),
      onChanged: widget.onChanged,
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.tab, required this.state});

  final VendorHomeOrderTab tab;
  final VendorHomeState state;

  @override
  Widget build(BuildContext context) {
    final resource = switch (tab) {
      VendorHomeOrderTab.processing => state.processingOrdersResource,
      VendorHomeOrderTab.archived => state.archivedOrdersResource,
    };
    final orders = switch (tab) {
      VendorHomeOrderTab.processing => state.processingOrders,
      VendorHomeOrderTab.archived => state.archivedOrders,
    };

    if (resource.state == Result.loading && orders.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (resource.state == Result.error && orders.isEmpty) {
      return SizedBox(height: 120, child: PrimaryEmptyData(onRetry: _retry));
    }

    if (orders.isEmpty) {
      return const SizedBox(height: 120, child: PrimaryEmptyData());
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (context, index) =>
          AppSpacing.vertical(AppDimensions.smallSpacing),
      itemBuilder: (context, index) {
        return _OrderCard(order: orders[index]);
      },
    );
  }

  void _retry() {
    final bloc = getIt.get<VendorHomeBloc>();

    switch (tab) {
      case VendorHomeOrderTab.processing:
        bloc.retryProcessingOrders();
        break;
      case VendorHomeOrderTab.archived:
        bloc.retryArchivedOrders();
        break;
    }
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final VendorOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);
    final iconPath = _iconPath(order.status);
    final createdAt =
        DateTimeUtils.formatDateTime(order.createdAt?.toLocal()) ?? '--';
    final totalAmount = order.collectAmount ?? order.codAmount ?? 0;

    return PrimaryFrame(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.xSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset(iconPath, width: 42, height: 42)),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  '#${order.trackingCode ?? '--'}',
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall,
                ),
                AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                PrimaryText(
                  order.customerName ?? '--',
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyXSmall,
                  color: AppColors.neutral5,
                ),
                AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                PrimaryText(
                  order.fullAddress ?? '--',
                  maxLine: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyXSmall,
                  color: AppColors.neutral5,
                ),
                AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                PrimaryText(
                  Utils.formatCurrencyWithUnit(totalAmount),
                  style: AppTextStyles.labelXSmall,
                ),
                AppSpacing.vertical(AppDimensions.xSmallSpacing),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.xSmallSpacing,
                        vertical: AppDimensions.xxSmallSpacing,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(18),
                        borderRadius: AppDimensions.smallBorderRadius,
                      ),
                      child: PrimaryText(
                        (order.status ?? '--').tr(),
                        style: AppTextStyles.bodyXXSmall.copyWith(
                          color: statusColor,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ),
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    Expanded(
                      child: PrimaryText(
                        createdAt,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyXXSmall.copyWith(
                          color: AppColors.neutral5,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
          // const Padding(
          //   padding: EdgeInsets.only(top: AppDimensions.mediumSpacing),
          //   child: Icon(
          //     Icons.chevron_right_rounded,
          //     color: AppColors.neutral5,
          //     size: AppDimensions.mediumIconSize,
          //   ),
          // ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivering':
      case 'in_transit':
        return AppColors.shopHomeV2Delivery;
      case 'delivered':
      case 'completed':
        return AppColors.successForeground;
      case 'cancelled':
      case 'canceled':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String _iconPath(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivering':
      case 'in_transit':
        return ImagePath.shopHomeV2OrderStatusDelivery;
      case 'delivered':
      case 'completed':
        return ImagePath.shopHomeV2OrderStatusDone;
      default:
        return ImagePath.shopHomeV2OrderStatusWaiting;
    }
  }
}
