import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_app_bar.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_box_shadows.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/features/shop_master/presentation/widgets/primary_bottom_navigation_bar.dart';
import 'package:oneship_customer/features/support/presentation/models/support_categories.dart';
import 'package:oneship_customer/features/support/presentation/models/support_category_data.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_contact_panel.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_faq_panel.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_hero.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_section_title.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_topic_grid.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SupportCategoryData> get _visibleCategories {
    final keyword = _normalize(_keyword);
    if (keyword.isEmpty) return supportCategories;

    return supportCategories.where((category) {
      final content = [
        category.titleKey.tr(),
        category.detailTitleKey.tr(),
        category.descriptionKey.tr(),
        ...category.questionKeys.map((key) => key.tr()),
      ].map(_normalize).join(' ');

      return content.contains(keyword);
    }).toList();
  }

  String _normalize(String value) => value.toLowerCase().replaceAll('\n', ' ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: PrimaryAppBar(
        title: 'support_help.page_title'.tr(),
        titleColor: AppColors.blue950,
      ),
      bottomNavigationBar: const PrimaryBottomNavigationBar(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
          children: [
            const SupportHero(),
            const SizedBox(height: 18),
            _SupportSearchBox(
              controller: _searchController,
              onChanged: (value) => setState(() => _keyword = value),
            ),
            const SizedBox(height: 22),
            SupportSectionTitle('support_help.popular_topics'.tr()),
            const SizedBox(height: 12),
            _visibleCategories.isEmpty
                ? const _SupportEmptySearchResult()
                : SupportTopicGrid(categories: _visibleCategories),
            const SizedBox(height: 22),
            const SupportContactPanel(),
            const SizedBox(height: 22),
            const SupportFaqPanel(),
          ],
        ),
      ),
    );
  }
}

class _SupportSearchBox extends StatelessWidget {
  const _SupportSearchBox({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.largeBorderRadius,
        boxShadow: AppBoxShadows.card,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'support_help.search_hint'.tr(),
          hintStyle: AppTextStyles.bodyXSmall.copyWith(
            color: AppColors.grey500,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.grey500,
            size: 24,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        style: AppTextStyles.bodyXSmall.copyWith(
          color: AppColors.blue950,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _SupportEmptySearchResult extends StatelessWidget {
  const _SupportEmptySearchResult();

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Center(
        child: PrimaryText(
          'support_help.no_search_result'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyXSmall.copyWith(color: AppColors.grey500),
        ),
      ),
    );
  }
}
