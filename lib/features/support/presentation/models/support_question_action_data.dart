import 'package:oneship_customer/features/support/presentation/models/support_web_view_data.dart';

enum SupportQuestionActionType { webView }

class SupportQuestionActionData {
  const SupportQuestionActionData.webView(this.webView)
    : type = SupportQuestionActionType.webView;

  final SupportQuestionActionType type;
  final SupportWebViewData? webView;
}

final supportQuestionActionByKey = {
  'support_help.categories.other.questions.policy':
      SupportQuestionActionData.webView(
        SupportWebViewData(
          titleKey: 'support_help.categories.other.questions.policy',
          url: 'https://ozoship.vn/dieu-khoan-su-dung/',
        ),
      ),
};
