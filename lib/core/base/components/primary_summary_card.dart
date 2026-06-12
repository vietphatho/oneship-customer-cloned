import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class PrimarySummaryCard extends StatelessWidget {
  const PrimarySummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconColor,
    required this.iconAsset,
    required this.watermarkAsset,
    this.backgroundImageAsset,
  });

  final String title;
  final String count;
  final String subtitle;
  final Color backgroundColor;
  final Color iconColor;
  final String iconAsset;
  final String watermarkAsset;
  final String? backgroundImageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.smallSpacing),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
        image: backgroundImageAsset != null
            ? DecorationImage(
                image: AssetImage(backgroundImageAsset!),
                fit: BoxFit.cover,
                alignment: Alignment.bottomRight,
              )
            : null,
      ),
      child: Stack(
        children: [
          // Watermark icon at the bottom right
          if (backgroundImageAsset == null)
            Positioned(
              right: -8,
              bottom: -8,
              child: Opacity(
                opacity: 0.2,
                child: SvgPicture.asset(
                  watermarkAsset,
                  width: 60,
                  height: 60,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
          // Main content
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryText(
                  title,
                  textAlign: TextAlign.center,
                  maxLine: 2,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: PrimaryText(
                  count,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: iconColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: PrimaryText(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutral4,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}
