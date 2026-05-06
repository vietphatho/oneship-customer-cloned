import 'package:oneship_customer/core/base/base_import_components.dart';

class Validators {
  static String? validateEmptyField(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.text_required".tr();
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.phone_required".tr();
    }
    final phoneRegex = RegExp(r'^(\+84|84|0)[3|5|7|8|9][0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return "validate.invalid_phone_format".tr();
    }
    return null;
  }
}
