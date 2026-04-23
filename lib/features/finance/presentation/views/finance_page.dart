import 'package:oneship_customer/core/base/base_import_components.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: PrimaryAppBar(title: "finance".tr()));
  }
}
