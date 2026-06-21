import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class SupportExpandableQuestionRow extends StatelessWidget {
  const SupportExpandableQuestionRow({
    super.key,
    required this.question,
    required this.isExpanded,
    required this.onTap,
  });

  final String question;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                const _QuestionIcon(),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryText(
                    question,
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: AppColors.blue950,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLine: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.chevron_right,
                  color: AppColors.grey500,
                  size: 22,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 8),
                child: PrimaryText(
                  'support_help.answer_placeholder'.tr(),
                  style: AppTextStyles.bodyXXSmall.copyWith(
                    color: AppColors.grey600,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SupportQuestionRow extends StatelessWidget {
  const SupportQuestionRow({super.key, required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const _QuestionIcon(),
          const SizedBox(width: 10),
          Expanded(
            child: PrimaryText(
              question,
              style: AppTextStyles.bodyXSmall.copyWith(
                color: AppColors.blue950,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLine: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.grey500, size: 22),
        ],
      ),
    );
  }
}

class _QuestionIcon extends StatelessWidget {
  const _QuestionIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.question_mark, color: AppColors.secondary, size: 18),
    );
  }
}
