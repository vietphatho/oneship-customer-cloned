import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintEntity complaint;
  final int index;
  final VoidCallback? onDelete;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.index,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PrimaryCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Text(
                '${(index + 1).toString().padLeft(2, '0')} | ',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.outline,
                ),
              ),
              Expanded(
                child: Text(
                  complaint.code,
                  style: AppTextStyles.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('complaints.created_at'.tr(), DateFormat('dd/MM/yyyy').format(complaint.createdAt)),
          _buildInfoRow('complaints.category'.tr(), 'complaints.${complaint.category}'.tr()),
          _buildInfoRow('complaints.priority'.tr(), 'complaints.priority_${complaint.priority}'.tr()),
          _buildInfoRow('complaints.title'.tr(), complaint.title),
          _buildInfoRow('complaints.description'.tr(), complaint.description),
          _buildInfoRow('complaints.reference_type'.tr(), 'complaints.reference_type_${complaint.referenceType}'.tr()),
          _buildInfoRow('complaints.reference_code'.tr(), complaint.referenceCode),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('complaints.status'.tr(), style: AppTextStyles.bodyMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(complaint.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'complaints.status_${complaint.status}'.tr(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _getStatusColor(complaint.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return AppColors.primary;
      case 'resolved':
        return AppColors.success;
      case 'closed':
        return AppColors.outline;
      default:
        return AppColors.primary;
    }
  }
}
