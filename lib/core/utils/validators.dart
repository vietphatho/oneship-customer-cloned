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
    if (trimmed.isEmpty) return 'Vui lòng nhập tên cửa hàng';
    if (trimmed.length < 3) return 'Tên cửa hàng phải có ít nhất 3 ký tự';
    return null;
  }

  static String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập email liên hệ';

    const emailPattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(trimmed)) {
      return 'Email không đúng định dạng';
    }

    return null;
  }

  static String? validatePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (!RegExp(r'^0\d{9,10}$').hasMatch(trimmed)) {
      return 'Số điện thoại Việt Nam không đúng định dạng';
    }
    return null;
  }

  static String? validateAddress(
    String value, {
    SuggestedAddressResponse? selectedAddress,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập địa chỉ';
    if (trimmed.length < 7) return 'Địa chỉ phải có ít nhất 7 ký tự';
    if (selectedAddress?.display != trimmed ||
        selectedAddress?.refId == null) {
      return 'Vui lòng chọn một địa chỉ từ danh sách gợi ý';
    }
    return null;
  }
}
