import 'package:flutter/material.dart';

class SupportCategoryData {
  const SupportCategoryData({
    required this.titleKey,
    required this.detailTitleKey,
    required this.descriptionKey,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.questionKeys,
    this.routeName,
  });

  final String titleKey;
  final String detailTitleKey;
  final String descriptionKey;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final List<String> questionKeys;
  final String? routeName;
}
