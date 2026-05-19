import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/components/primary_dismissible.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_bloc.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_state.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_event.dart';
import 'package:oneship_customer/features/complaints/presentation/widgets/complaint_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class ComplaintListView extends StatefulWidget {
  final String category;
  final RefreshController refreshController;

  const ComplaintListView({
    super.key,
    required this.category,
    required this.refreshController,
  });

  @override
  State<ComplaintListView> createState() => _ComplaintListViewState();
}

class _ComplaintListViewState extends State<ComplaintListView> {
  final ComplaintBloc _complaintBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _complaintBloc.add(ComplaintStarted(
      category: widget.category,
      shopId: getIt<ShopBloc>().state.currentShop?.shopId,
    ));
  }

  @override
  void dispose() {
    _complaintBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplaintBloc, ComplaintState>(
      bloc: _complaintBloc,
      builder: (context, state) {
        final resource = state.complaintsResource;
        final complaints = resource.data ?? <ComplaintEntity>[];

        if (resource.state == Result.loading && complaints.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (resource.state == Result.success || complaints.isNotEmpty) {
          widget.refreshController.refreshCompleted();
        } else if (resource.state == Result.error) {
          widget.refreshController.refreshFailed();
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
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        return PrimaryRefreshabelListView(
          controller: widget.refreshController,
          onRefresh: _complaintBloc.fetchComplaints,
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final complaint = complaints[index];
            return PrimaryDismissible(
              key: ValueKey(complaint.id),
              confirmMessage: 'complaints.delete_confirm'.tr(),
              onDismissed: (direction) {
                _complaintBloc.deleteComplaint(complaint.id);
              },
              child: ComplaintCard(
                complaint: complaint,
                index: index,
              ),
            );
          },
        );
      },
    );
  }
}
