import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';

class Validators {
  static String? validateEmptyField(String? value) {
    if (value == null || value.isEmpty) {
      return "validate.text_required".tr();
    }
    return null;
  }

  static String? validateShopName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'please_input_shop_name'.tr();
    if (trimmed.length < 3) return 'shop_name_min_length'.tr();
    return null;
  }

  static String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'please_input_email'.tr();

    const emailPattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(trimmed)) {
      return 'invalid_email_format'.tr();
    }

    return null;
  }

  static String? validatePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'please_input_phone'.tr();
    if (!RegExp(r'^0\d{9,10}$').hasMatch(trimmed)) {
      return 'invalid_phone_format'.tr();
    }
    return null;
  }

  static String? validateAddress(
    String value, {
    SuggestedAddressResponse? selectedAddress,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'please_input_address'.tr();
    if (trimmed.length < 7) return 'address_min_length'.tr();
    if (selectedAddress?.display != trimmed ||
        selectedAddress?.refId == null) {
      return 'please_select_address_from_suggestion'.tr();
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
