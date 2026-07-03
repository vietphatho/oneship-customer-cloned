import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_app_bar.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/features/shop_master/presentation/widgets/primary_bottom_navigation_bar.dart';
import 'package:oneship_customer/features/support/presentation/models/support_article_data.dart';
import 'package:oneship_customer/features/support/presentation/models/support_category_data.dart';
import 'package:oneship_customer/features/support/presentation/models/support_question_action_data.dart';
import 'package:oneship_customer/features/support/presentation/models/support_web_view_data.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_contact_panel.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_question_row.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_section_title.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportCategoryPage extends StatefulWidget {
  const SupportCategoryPage({super.key, required this.category});

  final SupportCategoryData category;

  @override
  State<SupportCategoryPage> createState() => _SupportCategoryPageState();
}

class _SupportCategoryPageState extends State<SupportCategoryPage> {
  int? _expandedQuestionIndex;

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PrimaryAppBar(
        title: category.detailTitleKey.tr(),
        titleColor: AppColors.blue950,
      ),
      bottomNavigationBar: const PrimaryBottomNavigationBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _SupportCategoryHeader(category: category),
            const SizedBox(height: 24),
            SupportSectionTitle('support_help.popular_questions'.tr()),
            const SizedBox(height: 10),
            PrimaryCard(
              child: Column(
                children: [
                  for (
                    int index = 0;
                    index < category.questionKeys.length;
                    index++
                  ) ...[
                    Builder(
                      builder: (context) {
                        final questionKey = category.questionKeys[index];
                        final action = supportQuestionActionByKey[questionKey];
                        final answer =
                            supportArticleDataByQuestionKey[questionKey]
                                ?.content
                                .tr();

                        return SupportExpandableQuestionRow(
                          question: questionKey.tr(),
                          answer: answer,
                          isExpanded:
                              action == null && _expandedQuestionIndex == index,
                          onTap: () {
                            if (action != null) {
                              _openSupportQuestionAction(context, action);
                              return;
                            }

                            setState(() {
                              _expandedQuestionIndex =
                                  _expandedQuestionIndex == index
                                  ? null
                                  : index;
                            });
                          },
                        );
                      },
                    ),
                    if (index != category.questionKeys.length - 1)
                      const Divider(height: 1, color: AppColors.grey200),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            SupportSectionTitle('support_help.still_need_support'.tr()),
            const SizedBox(height: 10),
            const SupportContactPanel(compact: true),
          ],
        ),
      ),
    );
  }

  void _openSupportQuestionAction(
    BuildContext context,
    SupportQuestionActionData action,
  ) {
    switch (action.type) {
      case SupportQuestionActionType.webView:
        _openSupportWebView(action.webView!);
    }
  }

  Future<void> _openSupportWebView(SupportWebViewData data) async {
    final isOpened = await launchUrl(
      Uri.parse(data.url),
      mode: LaunchMode.inAppBrowserView,
    );

    if (!isOpened && mounted) {
      PrimaryDialog.showErrorDialog(context, message: 'fetch_error');
    }
  }
}

class _SupportCategoryHeader extends StatelessWidget {
  const _SupportCategoryHeader({required this.category});

  final SupportCategoryData category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: category.iconBackgroundColor,
            borderRadius: AppDimensions.mediumBorderRadius,
          ),
          child: Icon(category.icon, color: category.iconColor, size: 30),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: PrimaryText(
            category.descriptionKey.tr(),
            style: AppTextStyles.bodyXSmall.copyWith(
              color: AppColors.grey600,
              fontSize: 16,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
