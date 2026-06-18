import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_box_shadows.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/features/support/presentation/models/support_category_data.dart';

class SupportTopicGrid extends StatelessWidget {
  const SupportTopicGrid({super.key, required this.categories});

  final List<SupportCategoryData> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppDimensions.smallSpacing,
        mainAxisSpacing: AppDimensions.smallSpacing,
        childAspectRatio: 1.08,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _SupportTopicItem(
          category: category,
          onTap: () {
            final routeName = category.routeName;
            if (routeName != null) {
              context.push(routeName);
              return;
            }
            context.push(RouteName.supportCategoryPage, extra: category);
          },
        );
      },
    );
  }
}

class _SupportTopicItem extends StatelessWidget {
  const _SupportTopicItem({
    required this.category,
    required this.onTap,
  });

  final SupportCategoryData category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.smallBorderRadius,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.smallBorderRadius,
          boxShadow: AppBoxShadows.card,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.xSmallSpacing,
                  AppDimensions.xSmallSpacing,
                  AppDimensions.largeSpacing,
                  AppDimensions.xSmallSpacing,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: category.iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(category.icon, color: category.iconColor, size: 24),
                    ),
                    const SizedBox(height: 6),
                    PrimaryText(
                      category.titleKey.tr(),
                      maxLine: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelXSmall.copyWith(
                        color: AppColors.blue950,
                        fontWeight: FontWeight.w600,
                        height: 1.12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.grey500,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
