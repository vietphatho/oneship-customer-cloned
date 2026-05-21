import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_image_thumbnail.dart';

class PrimaryImagePreviewThumbnail extends StatelessWidget {
  const PrimaryImagePreviewThumbnail({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
  });

  final String imageUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePreview(context),
      child: SizedBox(
        width: width,
        height: height,
        child: PrimaryImageThumbnail.network(imageUrl),
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    if (imageUrl.isEmpty) return;

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
                    child: Image.network(imageUrl, fit: BoxFit.contain),
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
