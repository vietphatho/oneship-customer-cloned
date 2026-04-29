import 'package:oneship_customer/core/base/base_import_components.dart';

class Validators {
  static String? validateEmptyField(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.text_required".tr();
    }
    return null;
  }
}
