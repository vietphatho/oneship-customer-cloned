import 'package:oneship_shop/core/base/base_import_components.dart';

class StringUtils {
  StringUtils._();

  static String? getImgUrl(String? path) {
    return "${Constants.imgEndpoint}/$path";
  }
}
