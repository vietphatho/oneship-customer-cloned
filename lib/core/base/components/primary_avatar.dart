import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_shop/core/base/constants/image_path.dart';
import 'package:oneship_shop/core/themes/app_colors.dart';

class PrimaryAvatar extends StatelessWidget {
  const PrimaryAvatar({
    super.key,
    this.url,
    this.radius,
    this.isOnline = false,
    this.showStatusIndicator = true,
  });

  final String? url;
  final double? radius;
  final bool isOnline;
  final bool showStatusIndicator;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = radius ?? 24.0;
    final statusIndicatorRadius = avatarRadius * 0.25;
    final avatarUrl = url?.trim();

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: avatarRadius,
          foregroundImage:
              avatarUrl?.isNotEmpty == true
                  ? CachedNetworkImageProvider(avatarUrl!)
                  : null,
          backgroundColor: AppColors.neutral8,
          child: SvgPicture.asset(
            ImagePath.iconUser,
            width: avatarRadius,
            height: avatarRadius,
            colorFilter: ColorFilter.mode(AppColors.neutral5, BlendMode.srcIn),
          ),
        ),
        // Status indicator
        if (showStatusIndicator)
          Container(
            width: statusIndicatorRadius * 2,
            height: statusIndicatorRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? Colors.green : AppColors.neutral6,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
      ],
    );
  }
}
