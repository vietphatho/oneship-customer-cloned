import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_question_row.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_section_title.dart';

class SupportFaqPanel extends StatefulWidget {
  const SupportFaqPanel({super.key});

  @override
  State<SupportFaqPanel> createState() => _SupportFaqPanelState();
}

class _SupportFaqPanelState extends State<SupportFaqPanel> {
  int? _expandedQuestionIndex;

  @override
  Widget build(BuildContext context) {
    final questions = [
      'support_help.faq.withdraw'.tr(),
      'support_help.faq.cancelled_order_payment'.tr(),
    ];

    return PrimaryCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: SupportSectionTitle('support_help.faq_title'.tr())),
              PrimaryText(
                'support_help.view_all'.tr(),
                style: AppTextStyles.bodyXSmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SupportExpandableQuestionRow(
            question: questions[0],
            isExpanded: _expandedQuestionIndex == 0,
            onTap: () {
              setState(() {
                _expandedQuestionIndex = _expandedQuestionIndex == 0 ? null : 0;
              });
            },
          ),
          const Divider(height: 1, color: AppColors.grey200),
          SupportExpandableQuestionRow(
            question: questions[1],
            isExpanded: _expandedQuestionIndex == 1,
            onTap: () {
              setState(() {
                _expandedQuestionIndex = _expandedQuestionIndex == 1 ? null : 1;
              });
            },
          ),
        ],
      ),
    );
  }
}
