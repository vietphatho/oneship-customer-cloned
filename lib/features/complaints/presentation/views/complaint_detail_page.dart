import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_app_bar.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class ComplaintDetailPage extends StatelessWidget {
  const ComplaintDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final complaint = GoRouterState.of(context).extra as ComplaintEntity;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PrimaryAppBar(
        title: 'Chi tiết khiếu nại',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Mã khiếu nại', complaint.code),
              const Divider(height: 24),
              _buildDetailRow('Đơn hàng', '#${complaint.referenceCode}'),
              const Divider(height: 24),
              _buildDetailRow('Người gửi', complaint.creatorName ?? 'N/A'),
              const Divider(height: 24),
              _buildDetailRow('Thời gian tạo', DateFormat('dd/MM/yyyy • HH:mm').format(complaint.createdAt.toLocal())),
              const Divider(height: 24),
              _buildDetailRow('Trạng thái', _getStatusText(complaint.status)),
              const Divider(height: 24),
              _buildDetailRow('Tiêu đề', complaint.title),
              const Divider(height: 24),
              PrimaryText(
                'Nội dung chi tiết',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
              ),
              const SizedBox(height: 8),
              PrimaryText(
                complaint.description.isNotEmpty ? complaint.description : 'Không có nội dung',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey900),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: PrimaryText(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: PrimaryText(
            value,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey900, fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
      case 'open':
        return 'Đang xử lý';
      case 'resolved':
      case 'closed':
        return 'Đã xử lý';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Đang xử lý';
    }
  }
}
