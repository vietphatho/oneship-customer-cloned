import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';

class PrimaryAssetAvatar extends StatelessWidget {
  const PrimaryAssetAvatar({
    super.key,
    required this.image,
    required this.backgroundImage,
    this.radius,
    this.imageSize,
    this.overlayImage,
    this.overlaySize,
    this.isOnline = false,
    this.showStatusIndicator = false,
  });

  final String image;
  final String backgroundImage;
  final double? radius;
  final double? imageSize;
  final String? overlayImage;
  final double? overlaySize;
  final bool isOnline;
  final bool showStatusIndicator;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = radius ?? AppDimensions.homeAvatarRadius;
    final statusIndicatorRadius = avatarRadius * 0.25;
    final size = avatarRadius * 2;
    final avatarImageSize =
        imageSize ?? avatarRadius + AppDimensions.xSmallSpacing;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Image.asset(backgroundImage, fit: BoxFit.contain),
                Center(
                  child: Image.asset(
                    image,
                    width: avatarImageSize,
                    height: avatarImageSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
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
          if (overlayImage != null)
            Image.asset(
              overlayImage!,
              width: overlaySize ?? avatarRadius * 0.55,
              height: overlaySize ?? avatarRadius * 0.55,
              fit: BoxFit.contain,
            ),
        ],
      ),
    );
  }
}
