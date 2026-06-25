import 'package:oneship_customer/core/base/base_import_components.dart';

class VendorOrderSearchBox extends StatefulWidget {
  const VendorOrderSearchBox({
    super.key,
    required this.keyword,
    required this.onChanged,
  });

  final String keyword;
  final ValueChanged<String> onChanged;

  @override
  State<VendorOrderSearchBox> createState() => _VendorOrderSearchBoxState();
}

class _VendorOrderSearchBoxState extends State<VendorOrderSearchBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.keyword);
  }

  @override
  void didUpdateWidget(covariant VendorOrderSearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyword != _controller.text) {
      _controller.text = widget.keyword;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: _controller,
      hintText: 'vendor_home.orders.search_hint'.tr(),
      textInputAction: TextInputAction.search,
      fillColor: Colors.white,
      suffixIcon: const Icon(
        Icons.search_rounded,
        color: AppColors.neutral1,
        size: AppDimensions.mediumIconSize,
      ),
      onChanged: widget.onChanged,
    );
  }
}
