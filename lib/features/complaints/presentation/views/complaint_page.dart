import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/base/components/primary_app_bar.dart';
import 'package:oneship_customer/core/base/components/primary_chip_tab_bar.dart';
import 'package:oneship_customer/core/base/components/primary_summary_card.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/base/components/primary_text_field.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_bloc.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_state.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_event.dart';
import 'package:oneship_customer/features/complaints/presentation/widgets/complaint_list_view.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_master/presentation/widgets/primary_bottom_navigation_bar.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final ComplaintBloc _complaintBloc = getIt.get();
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  int _selectedTabIndex = 0;

  List<String> get _tabs => [
    'Tất cả',
    'Đang xử lý',
    'Đã xử lý',
    'Đã hủy',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    _complaintBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(context),
      bottomNavigationBar: const PrimaryBottomNavigationBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 16),
          _buildFilterBar(),
          const SizedBox(height: 16),
          PrimaryChipTabBar(
            tabs: _tabs,
            tabColors: const [
              AppColors.orange,
              AppColors.secondary,
              AppColors.green,
              AppColors.grey500,
            ],
            selectedIndex: _selectedTabIndex,
            onChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
              _refreshController.requestRefresh();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ComplaintListView(
              bloc: _complaintBloc,
              category: 'order_issue',
              status: _getStatusFromTabIndex(_selectedTabIndex),
              refreshController: _refreshController,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PrimaryAppBar(
      title: 'Khiếu nại - Sự cố',
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.search, color: AppColors.grey500),
        //   onPressed: () {},
        // ),
        // IconButton(
        //   icon: const Icon(Icons.filter_alt_outlined, color: AppColors.grey500),
        //   onPressed: () {},
        // ),
        IconButton(
          icon: const Icon(Icons.add, color: AppColors.orange),
          onPressed: () async {
            final result = await context.push(RouteName.createComplaintPage);
            if (result == true) {
              _complaintBloc.add(ComplaintStarted(
                category: 'order_issue',
                shopId: getIt<ShopBloc>().state.currentShop?.shopId,
                status: _getStatusFromTabIndex(_selectedTabIndex),
              ));
            }
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return BlocBuilder<ComplaintBloc, ComplaintState>(
      bloc: _complaintBloc,
      builder: (context, state) {
        final summary = state.summaryResource.data as Map<String, dynamic>? ?? {};
        final openCount = (summary['open'] as num?)?.toInt() ?? 0;
        final resolvedCount = (summary['resolved'] as num?)?.toInt() ?? 0;
        final closedCount = (summary['closed'] as num?)?.toInt() ?? 0;
        
        final processingStr = openCount.toString();
        final processedStr = (resolvedCount + closedCount).toString();
        
        final totalCount = (summary['total'] as num?)?.toInt() ?? 
            (summary.values.fold<int>(0, (sum, val) => sum + ((val as num?)?.toInt() ?? 0)));
        final totalStr = totalCount.toString();
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: PrimarySummaryCard(
                  title: 'Tổng yêu cầu',
                  count: totalStr,
                  subtitle: 'Yêu cầu',
                  backgroundColor: AppColors.orange100.withValues(alpha: 0.1),
                  iconColor: AppColors.orange,
                  iconAsset: SvgPath.icShopHomePackage,
                  watermarkAsset: SvgPath.icShopHomePackage,
                  backgroundImageAsset: 'assets/images/bg_total_complaints.png',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimarySummaryCard(
                  title: 'Đang xử lý',
                  count: processingStr,
                  subtitle: 'Yêu cầu',
                  backgroundColor: AppColors.blue100.withValues(alpha: 0.3),
                  iconColor: AppColors.secondary,
                  iconAsset: SvgPath.icOrderProcessing,
                  watermarkAsset: SvgPath.icOrderProcessing,
                  backgroundImageAsset: 'assets/images/bg_processing_complaints.png',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimarySummaryCard(
                  title: 'Đã xử lý',
                  count: processedStr,
                  subtitle: 'Yêu cầu',
                  backgroundColor: AppColors.green100.withValues(alpha: 0.3),
                  iconColor: AppColors.green,
                  iconAsset: SvgPath.icOrderProcessed,
                  watermarkAsset: SvgPath.icOrderProcessed,
                  backgroundImageAsset: 'assets/images/bg_processed_complaints.png',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PrimaryTextField(
                hintText: 'Tìm kiếm theo mã, đơn hàng, người gửi...',
                controller: _searchController,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.neutral7),
                  borderRadius: AppDimensions.largeBorderRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(width: 8),
                    PrimaryText(
                      'Chọn thời gian',
                      style: TextStyle(color: AppColors.grey500, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppColors.grey500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getStatusFromTabIndex(int index) {
    switch (index) {
      case 1:
        return 'open';
      case 2:
        return 'resolved';
      case 3:
        return 'closed';
      case 0:
      default:
        return null;
    }
  }
}
