import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:easy_localization/easy_localization.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({
    super.key,
    required this.complaint,
    this.onTap,
  });

  final ComplaintEntity complaint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    complaint.code,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Đơn hàng:', '#${complaint.referenceCode}'),
                  const SizedBox(height: 4),
                  _buildDetailRow('Nội dung:', complaint.title),
                  const SizedBox(height: 4),
                  _buildDetailRow('Người gửi:', complaint.creatorName ?? 'N/A'),
                  const SizedBox(height: 4),
                  _buildDetailRow('Thời gian:', DateFormat('dd/MM/yyyy • HH:mm').format(complaint.createdAt.toLocal())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grey600,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: PrimaryText(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    String iconPath;

    switch (complaint.status.toLowerCase()) {
      case 'processing':
      case 'open':
        iconPath = 'assets/icons/ic_status_processing.png';
        break;
      case 'resolved':
      case 'closed':
        iconPath = 'assets/icons/ic_status_delivering.png';
        break;
      case 'cancelled':
        iconPath = 'assets/icons/ic_status_cancelled.png';
        break;
      default:
        iconPath = 'assets/icons/ic_status_processing.png';
    }

    return Image.asset(
      iconPath,
      width: 48,
      height: 48,
    );
  }
}
