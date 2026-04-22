import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';

class ShopBriefInfo extends StatelessWidget {
  const ShopBriefInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumSpacing,
      ),
      child: PrimaryCard(
        child: Column(
          children: [
            _InfoField(label: "today_total_orders".tr(), value: "5"),
            const Divider(),
            _InfoField(label: "today_total_cod".tr(), value: "5000"),
            const Divider(),
            _InfoField(label: "today_total_expense".tr(), value: "4000"),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    super.key,
    // required this.icon,
    required this.label,
    required this.value,
  });

  // final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [Icon(Icons.ac_unit_rounded), PrimaryText(label)]),
        PrimaryText(value),
      ],
    );
  }
}
