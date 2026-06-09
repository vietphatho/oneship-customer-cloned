import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PrimaryText(
                          complaint.code,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusIndicator(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Đơn hàng:', '#${complaint.referenceCode}'),
                  const SizedBox(height: 4),
                  _buildDetailRow('Nội dung:', complaint.title),
                  const SizedBox(height: 4),
                  _buildDetailRow('Người gửi:', 'Nguyễn Văn A'), // Mocked as per design
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryText(
                      DateFormat('dd/MM/yyyy • HH:mm').format(complaint.createdAt),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.grey400,
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
    Color bgColor;
    String iconPath;

    switch (complaint.category) {
      case 'delivery_issue':
        bgColor = AppColors.blue100;
        iconPath = SvgPath.icShopHomeStaff; // Or truck icon if available
        break;
      case 'product_issue':
        bgColor = AppColors.green100;
        iconPath = SvgPath.icShopHomePackage;
        break;
      case 'service_issue':
        bgColor = AppColors.green100;
        iconPath = SvgPath.icShopHomeSupport;
        break;
      default:
        bgColor = AppColors.orange100;
        iconPath = SvgPath.icShopHomePackage;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color statusColor;
    String statusText;

    switch (complaint.status.toLowerCase()) {
      case 'processing':
      case 'open':
        statusColor = AppColors.orange;
        statusText = 'Đang xử lý';
        break;
      case 'resolved':
      case 'closed':
        statusColor = AppColors.green;
        statusText = 'Đã xử lý';
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        statusText = 'Đã hủy';
        break;
      default:
        statusColor = AppColors.orange;
        statusText = 'Đang xử lý';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        PrimaryText(
          statusText,
          style: AppTextStyles.labelMedium.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
