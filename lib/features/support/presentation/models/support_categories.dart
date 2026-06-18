import 'package:flutter/material.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/features/support/presentation/models/support_category_data.dart';

const supportCategories = [
  SupportCategoryData(
    titleKey: 'support_help.categories.account.title',
    detailTitleKey: 'support_help.categories.account.detail_title',
    descriptionKey: 'support_help.categories.account.description',
    icon: Icons.account_balance_wallet_outlined,
    iconColor: AppColors.secondary,
    iconBackgroundColor: AppColors.supportAccountBackground,
    questionKeys: [
      'support_help.categories.account.questions.login_failed',
      'support_help.categories.account.questions.forgot_password',
      'support_help.categories.account.questions.change_phone',
      'support_help.categories.account.questions.kyc',
      'support_help.categories.account.questions.locked',
    ],
  ),
  SupportCategoryData(
    titleKey: 'support_help.categories.income.title',
    detailTitleKey: 'support_help.categories.income.detail_title',
    descriptionKey: 'support_help.categories.income.description',
    icon: Icons.payments_outlined,
    iconColor: AppColors.green,
    iconBackgroundColor: AppColors.supportIncomeBackground,
    questionKeys: [
      'support_help.categories.income.questions.receive_money_time',
      'support_help.categories.income.questions.withdraw',
      'support_help.categories.income.questions.wrong_income',
      'support_help.categories.income.questions.transaction_history',
      'support_help.categories.income.questions.service_fee',
    ],
  ),
  SupportCategoryData(
    titleKey: 'support_help.categories.package.title',
    detailTitleKey: 'support_help.categories.package.detail_title',
    descriptionKey: 'support_help.categories.package.description',
    icon: Icons.shopping_bag_outlined,
    iconColor: AppColors.investmentPurple,
    iconBackgroundColor: AppColors.supportPackageBackground,
    questionKeys: [
      'support_help.categories.package.questions.missing_or_error',
      'support_help.categories.package.questions.how_to_use',
      'support_help.categories.package.questions.delivery_failed',
      'support_help.categories.package.questions.change_address',
      'support_help.categories.package.questions.delivery_time',
    ],
  ),
  SupportCategoryData(
    titleKey: 'support_help.categories.app_feature.title',
    detailTitleKey: 'support_help.categories.app_feature.detail_title',
    descriptionKey: 'support_help.categories.app_feature.description',
    icon: Icons.settings,
    iconColor: AppColors.info,
    iconBackgroundColor: AppColors.supportAppFeatureBackground,
    questionKeys: [
      'support_help.categories.app_feature.questions.app_error',
      'support_help.categories.app_feature.questions.update_app',
      'support_help.categories.app_feature.questions.scan_failed',
      'support_help.categories.app_feature.questions.notification_missing',
      'support_help.categories.app_feature.questions.suggestion',
    ],
  ),
  SupportCategoryData(
    titleKey: 'support_help.categories.complaint.title',
    detailTitleKey: 'support_help.categories.complaint.detail_title',
    descriptionKey: 'support_help.categories.complaint.description',
    icon: Icons.warning_amber_rounded,
    iconColor: AppColors.error,
    iconBackgroundColor: AppColors.supportComplaintBackground,
    routeName: RouteName.complaintPage,
    questionKeys: [
      'support_help.categories.complaint.questions.create',
      'support_help.categories.complaint.questions.tracking',
      'support_help.categories.complaint.questions.order',
      'support_help.categories.complaint.questions.payment',
      'support_help.categories.complaint.questions.general',
    ],
  ),
  SupportCategoryData(
    titleKey: 'support_help.categories.other.title',
    detailTitleKey: 'support_help.categories.other.detail_title',
    descriptionKey: 'support_help.categories.other.description',
    icon: Icons.more_horiz,
    iconColor: AppColors.grey500,
    iconBackgroundColor: AppColors.supportOtherBackground,
    questionKeys: [
      'support_help.categories.other.questions.feedback',
      'support_help.categories.other.questions.promotion',
      'support_help.categories.other.questions.partner',
      'support_help.categories.other.questions.policy',
      'support_help.categories.other.questions.general_complaint',
    ],
  ),
];
