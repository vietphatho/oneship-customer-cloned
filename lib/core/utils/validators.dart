import 'package:oneship_customer/core/base/base_import_components.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.email_required".tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "validate.invalid_email_format".tr();
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.username_required".tr();
    }
    if (value.length < 3) {
      return "validate.username_min_length".tr();
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.full_name_required".tr();
    }
    if (value.length < 2) {
      return "validate.full_name_min_length".tr();
    }
    return null;
  }

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

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.password_required".tr();
    }
    if (value.length < 6) {
      return "validate.password_min_length".tr();
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return "validate.confirm_password_required".tr();
    }
    if (value != originalPassword) {
      return "validate.confirm_password_mismatch".tr();
    }
    return null;
  }
}
