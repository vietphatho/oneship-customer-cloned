import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/components/primary_dismissible.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_bloc.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_state.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_event.dart';
import 'package:oneship_customer/features/complaints/presentation/widgets/complaint_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class ComplaintListView extends StatefulWidget {
  final ComplaintBloc bloc;
  final String category;
  final String? status;
  final RefreshController refreshController;

  const ComplaintListView({
    super.key,
    required this.bloc,
    required this.category,
    this.status,
    required this.refreshController,
  });

  @override
  State<ComplaintListView> createState() => _ComplaintListViewState();
}

class _ComplaintListViewState extends State<ComplaintListView> {

  @override
  void initState() {
    super.initState();
    widget.bloc.add(ComplaintStarted(
      category: widget.category,
      shopId: getIt<ShopBloc>().state.currentShop?.shopId,
      status: widget.status,
    ));
  }

  @override
  void didUpdateWidget(covariant ComplaintListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      widget.bloc.add(ComplaintStarted(
        category: widget.category,
        shopId: getIt<ShopBloc>().state.currentShop?.shopId,
        status: widget.status,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplaintBloc, ComplaintState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final resource = state.complaintsResource;
        final complaints = resource.data ?? <ComplaintEntity>[];

        if (resource.state == Result.loading && complaints.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (resource.state == Result.success || complaints.isNotEmpty) {
          widget.refreshController.refreshCompleted();
          widget.refreshController.loadComplete();
        } else if (resource.state == Result.error) {
          widget.refreshController.refreshFailed();
          widget.refreshController.loadFailed();
        }

        if (!state.canLoadMore && complaints.isNotEmpty) {
          widget.refreshController.loadNoData();
        }

        if (resource.state == Result.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                PrimaryText(
                  resource.message.isNotEmpty ? resource.message : 'complaints.fetch_error'.tr(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (complaints.isEmpty) {
          return Center(
            child: PrimaryText(
              'complaints.empty_list'.tr(),
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.grey500,
                fontSize: 16,
              ),
            ),
          );
        }

        return PrimaryRefreshabelListView(
          controller: widget.refreshController,
          onRefresh: widget.bloc.fetchComplaints,
          enablePullUp: true,
          onLoading: () => widget.bloc.add(const ComplaintLoadMore()),
          itemCount: complaints.length,
          footerBottomSpacing: 112.0,
          itemBuilder: (context, index) {
            final complaint = complaints[index];
            return PrimaryDismissible(
              key: ValueKey(complaint.id),
              confirmMessage: 'complaints.delete_confirm'.tr(),
              onDismissed: (direction) {
                widget.bloc.deleteComplaint(complaint.id);
              },
              child: ComplaintCard(
                complaint: complaint,
                onTap: () {
                  context.push(RouteName.complaintDetailPage, extra: complaint);
                },
              ),
            );
          },
        );
      },
    );
  }
}
