import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/auth/presentation/views/verify_secondary_password_page.dart';

class VendorFinanceVerifySecondaryPasswordPage extends StatelessWidget {
  const VendorFinanceVerifySecondaryPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const PrimaryAppBar(title: ''),
      body: VerifySecondaryPasswordPage(
        titleKey: 'secondary_password.vendor_finance_verify_title',
        descriptionKey: 'secondary_password.vendor_finance_verify_description',
        showSecureNote: false,
        onCallback: () => context.pop(true),
      ),
    );
  }
}
