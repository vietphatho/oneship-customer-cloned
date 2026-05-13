import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_app_bar.dart';
import 'package:oneship_customer/core/base/components/primary_tab_bar.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_bloc.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_event.dart';
import 'package:oneship_customer/features/complaints/presentation/widgets/complaint_list_view.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:go_router/go_router.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const List<String> _tabs = ['complaints.order_issue', 'complaints.delivery_issue'];
  static const List<String> _serverCategories = ['order_issue', 'delivery_issue'];

  // Mỗi tab có RefreshController riêng
  final List<RefreshController> _refreshControllers = [
    RefreshController(),
    RefreshController(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _refreshControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBar(),
          const SizedBox(height: 16),
          _buildListHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_tabs.length, (index) {
                return BlocProvider(
                  key: ValueKey(_tabs[index]),
                  create: (_) => getIt<ComplaintBloc>()
                    ..add(ComplaintEvent.started(category: _tabs[index])),
                  child: ComplaintListView(
                    refreshController: _refreshControllers[index],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PrimaryAppBar(
      title: 'complaints.page_title'.tr(),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: AppColors.secondary, size: 30),
          onPressed: () async {
            final int currentTab = _tabController.index;
            final result = await context.push(RouteName.createComplaintPage);
            if (result == true && context.mounted) {
              // Tìm BlocProvider của tab hiện tại để refresh
              // Vì mỗi tab có Bloc riêng, chỉ cần setState để trigger rebuild
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return PrimaryTabBar(
      items: _tabs.map((e) => e.tr()).toList(),
      controller: _tabController,
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'complaints.list_title'.tr(),
        style: AppTextStyles.titleLarge,
      ),
    );
  }
}
