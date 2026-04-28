import 'package:oneship_customer/core/base/base_import_components.dart';

class Validators {
  static String? validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return "error_code.validate.text_required".tr();
    }
    return null;
  }
}
