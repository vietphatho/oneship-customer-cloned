import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';

class PrimaryImageThumbnail extends StatelessWidget {
  const PrimaryImageThumbnail._internal({super.key, this.url, this.filePath});

  final String? url;
  final String? filePath;

  factory PrimaryImageThumbnail.network(String url) =>
      PrimaryImageThumbnail._internal(url: url);

  factory PrimaryImageThumbnail.file(String filePath) =>
      PrimaryImageThumbnail._internal(filePath: filePath);

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(url!),
            fit: BoxFit.cover,
          ),
          borderRadius: AppDimensions.mediumBorderRadius,
        ),
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
}
