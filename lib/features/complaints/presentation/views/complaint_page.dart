import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/filter_text_field.dart';
import 'package:oneship_customer/core/base/components/primary_app_bar.dart';
import 'package:oneship_customer/core/base/components/primary_chip_tab_bar.dart';
import 'package:oneship_customer/core/base/components/primary_pagination.dart';
import 'package:oneship_customer/core/base/components/primary_summary_card.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/features/complaints/presentation/widgets/complaint_list_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _tabs = [
    'Tất cả (32)',
    'Đang xử lý (12)',
    'Đã xử lý (18)',
    'Đã hủy (2)'
  ];

  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
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
          _buildSummaryCards(),
          const SizedBox(height: 16),
          _buildFilterBar(),
          const SizedBox(height: 16),
          PrimaryChipTabBar(
            tabs: _tabs,
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
              category: 'all', // Or appropriate category based on tab
              refreshController: _refreshController,
            ),
          ),
          _buildPagination(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PrimaryAppBar(
      title: 'Khiếu nại – Sự cố',
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.grey500),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined, color: AppColors.grey500),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: PrimarySummaryCard(
              title: 'Tổng khiếu nại',
              count: '32',
              subtitle: 'Yêu cầu',
              backgroundColor: AppColors.orange100.withValues(alpha: 0.1),
              iconColor: AppColors.orange,
              iconAsset: SvgPath.icShopHomePackage, // Placeholder icon
              watermarkAsset: SvgPath.icShopHomePackage,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PrimarySummaryCard(
              title: 'Đang xử lý',
              count: '12',
              subtitle: 'Yêu cầu',
              backgroundColor: AppColors.blue100.withValues(alpha: 0.3),
              iconColor: AppColors.secondary,
              iconAsset: SvgPath.icOrderProcessing, // Placeholder icon
              watermarkAsset: SvgPath.icOrderProcessing,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PrimarySummaryCard(
              title: 'Đã xử lý',
              count: '18',
              subtitle: 'Yêu cầu',
              backgroundColor: AppColors.green100.withValues(alpha: 0.3),
              iconColor: AppColors.green,
              iconAsset: SvgPath.icOrderProcessed, // Placeholder icon
              watermarkAsset: SvgPath.icOrderProcessed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: FilterTextField(
              label: '',
              hintText: 'Tìm kiếm theo mã, đơn hàng, người gửi...',
              controller: _searchController,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                final dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (dateRange != null) {
                  // Handle date range
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.grey500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Chọn thời gian',
                        style: TextStyle(color: AppColors.grey500, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.grey500),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: PrimaryPagination(
        currentPage: 1,
        totalPages: 5,
        totalItems: 32,
        itemsPerPage: 6,
        onPageChanged: (page) {},
      ),
    );
  }
}
