import 'package:cached_network_image/cached_network_image.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';

Future<void> showProfileAvatarPreview(
  BuildContext context, {
  required String? avatarUrl,
}) async {
  final url = avatarUrl?.trim();
  if (url == null || url.isEmpty) {
    PrimaryDialog.showErrorDialog(context, message: 'Avatar not available');
    return;
  }

  await PrimaryDialog.showDefaultDialog(
    context,
    child: Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Center(
                child: Hero(
                  tag: Constants.profileAvatarHeroKey,
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4,
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white,
                        size: AppDimensions.displayIconSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppDimensions.mediumSpacing,
              right: AppDimensions.mediumSpacing,
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: AppDimensions.largeIconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
