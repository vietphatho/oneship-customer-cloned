import 'package:injectable/injectable.dart';

@lazySingleton
class ValidateCreateOrderInfoUseCase {
  String? validateConfirmInfoStep(bool acceptTerms) {
    if (!acceptTerms) {
      return "please_accept_terms";
    }
    return null;
  }
}
