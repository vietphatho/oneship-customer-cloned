import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';

class PrimaryAvatar extends StatelessWidget {
  const PrimaryAvatar({
    super.key,
    this.url,
    this.radius,
    this.isOnline = false,
  });

  final String? url;
  final double? radius;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = radius ?? 24.0;
    final statusIndicatorRadius = avatarRadius * 0.25;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: avatarRadius,
          foregroundImage:
              url != null ? CachedNetworkImageProvider(url!) : null,
          backgroundColor: AppColors.neutral8,
          // backgroundImage: AssetImage(ImagePath.iconUser),
        ),
        // Status indicator
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
