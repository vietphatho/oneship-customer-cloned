import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';

class PrimaryImageThumbnail extends StatelessWidget {
  const PrimaryImageThumbnail._internal({
    super.key,
    this.url,
    this.filePath,
    this.canPreview = false,
  });

  final String? url;
  final String? filePath;
  final bool canPreview;

  factory PrimaryImageThumbnail.network(String url, {bool canPreview = false}) =>
      PrimaryImageThumbnail._internal(url: url, canPreview: canPreview);

  factory PrimaryImageThumbnail.file(String filePath) =>
      PrimaryImageThumbnail._internal(filePath: filePath);

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      final thumbnail = Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(url!),
            fit: BoxFit.cover,
          ),
          borderRadius: AppDimensions.mediumBorderRadius,
        ),
      );

      if (!canPreview) return thumbnail;

      return GestureDetector(
        onTap: () => _showImagePreview(context),
        child: thumbnail,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(filePath!)),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  void _showImagePreview(BuildContext context) {
    if (url?.isEmpty ?? true) return;

    PrimaryDialog.showDefaultDialog(
      context,
      child: GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Material(
          color: Colors.black.withOpacity(0.85),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4,
                    child: Image.network(url!, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: AppDimensions.mediumSpacing,
                  right: AppDimensions.mediumSpacing,
                  child: IconButton(
                    onPressed:
                        () => Navigator.of(context, rootNavigator: true).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
