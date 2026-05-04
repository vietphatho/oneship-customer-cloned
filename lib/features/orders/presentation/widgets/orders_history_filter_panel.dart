import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_filters.dart';

class OrdersHistoryFilterPanel extends StatefulWidget {
  const OrdersHistoryFilterPanel({
    super.key,
    required this.initialFilters,
    required this.maxCodAmount,
    required this.onApply,
    required this.onClear,
  });

  final OrdersHistoryFilters initialFilters;
  final double maxCodAmount;
  final ValueChanged<OrdersHistoryFilters> onApply;
  final VoidCallback onClear;

  @override
  State<OrdersHistoryFilterPanel> createState() =>
      _OrdersHistoryFilterPanelState();
}

class _OrdersHistoryFilterPanelState extends State<OrdersHistoryFilterPanel> {
  static const int _hcmProvinceCode = 79;

  final _cityController = TextEditingController(text: "Thành phố Hồ Chí Minh");
  final _phoneController = TextEditingController();
  final _orderCodeController = TextEditingController();
  final _dateController = TextEditingController();

  List<Province> _provinces = const [];
  Map<String, List<Ward>> _wardsByProvince = const {};
  Province? _selectedProvince;
  Ward? _selectedWard;
  DateTime? _selectedDate;
  late RangeValues _codRange;

  List<Ward> get _wards {
    if (_selectedProvince == null) return const [];
    return _wardsByProvince[_selectedProvince!.code.toString()] ?? const [];
  }

  @override
  void initState() {
    super.initState();
    _selectedProvince =
        widget.initialFilters.province?.code == _hcmProvinceCode
            ? widget.initialFilters.province
            : null;
    _selectedWard = widget.initialFilters.ward;
    _selectedDate = widget.initialFilters.createdDate;
    _codRange = widget.initialFilters.codRange;
    _phoneController.text = widget.initialFilters.phone;
    _orderCodeController.text = widget.initialFilters.orderCode;
    if (_selectedDate != null) {
      _dateController.text = _formatDate(_selectedDate!);
    }
    _loadRegions();
  }

  @override
  void didUpdateWidget(covariant OrdersHistoryFilterPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxCodAmount != widget.maxCodAmount &&
        _codRange.end > widget.maxCodAmount) {
      _codRange = RangeValues(
        math.min(_codRange.start, widget.maxCodAmount).toDouble(),
        widget.maxCodAmount,
      );
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _phoneController.dispose();
    _orderCodeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxCodAmount = math.max(widget.maxCodAmount, 1000000).toDouble();
    final displayedRange = RangeValues(
      _codRange.start.clamp(0, maxCodAmount).toDouble(),
      _codRange.end.clamp(0, maxCodAmount).toDouble(),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.largeSpacing),
      padding: const EdgeInsets.all(AppDimensions.smallSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.xSmallBorderRadius,
        border: Border.all(color: AppColors.neutral8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CompactTextField(
            label: "Thành phố",
            hintText: "Thành phố Hồ Chí Minh",
            controller: _cityController,
            enabled: false,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _CompactWardDropdown(
            label: "Xã/Phường",
            hintText: "Chọn xã/phường",
            wards: _wards,
            selectedWard: _selectedWard,
            onSelected: (ward) {
              setState(() {
                _selectedWard = ward;
              });
            },
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _CompactTextField(
            label: "Số điện thoại",
            hintText: "Nhập",
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: _CompactTextField(
                label: "Chọn ngày",
                hintText: "Nhập",
                controller: _dateController,
                suffixIcon: const Icon(
                  Icons.calendar_month,
                  size: AppDimensions.smallIconSize,
                  color: AppColors.neutral5,
                ),
              ),
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _CompactTextField(
            label: "Mã đơn hàng",
            hintText: "Nhập",
            controller: _orderCodeController,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _OrdersHistoryCodRangeField(
            values: displayedRange,
            maxCodAmount: maxCodAmount,
            onChanged: (values) {
              setState(() {
                _codRange = values;
              });
            },
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.xSmallRadius,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Lọc kết quả",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.horizontal(AppDimensions.smallSpacing),
              Expanded(
                child: TextButton(
                  onPressed: _clearFilters,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.neutral6,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text("Xóa bộ lọc"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadRegions() async {
    final provinceStr =
        await rootBundle.loadString('assets/json/provinces.json');
    final provinceJson = jsonDecode(provinceStr) as List;
    final provinces =
        provinceJson
            .map((e) => Province.fromJson(e))
            .where((province) => province.code == _hcmProvinceCode)
            .toList();

    final wardStr = await rootBundle.loadString('assets/json/wards.json');
    final wardJson = jsonDecode(wardStr) as List;
    final wards =
        wardJson
            .map((e) => Ward.fromJson(e))
            .where((ward) => ward.provinceCode == _hcmProvinceCode)
            .toList();

    final wardsByProvince = <String, List<Ward>>{};
    for (final ward in wards) {
      wardsByProvince
          .putIfAbsent(ward.provinceCode.toString(), () => [])
          .add(ward);
    }

    if (!mounted) return;
    setState(() {
      _provinces = provinces;
      _wardsByProvince = wardsByProvince;
      _selectedProvince = provinces.isNotEmpty ? provinces.first : null;
      _cityController.text =
          _selectedProvince?.name ?? "Thành phố Hồ Chí Minh";
      if (_selectedWard != null &&
          _selectedWard!.provinceCode != _hcmProvinceCode) {
        _selectedWard = null;
      }
    });
  }

  void _applyFilters() {
    final maxCodAmount = math.max(widget.maxCodAmount, 1000000).toDouble();
    widget.onApply(
      OrdersHistoryFilters(
        province: _selectedProvince,
        ward: _selectedWard,
        createdDate: _selectedDate,
        phone: _phoneController.text.trim(),
        orderCode: _orderCodeController.text.trim(),
        codRange: RangeValues(
          _codRange.start.clamp(0, maxCodAmount).toDouble(),
          _codRange.end.clamp(0, maxCodAmount).toDouble(),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedProvince = _provinces.isNotEmpty ? _provinces.first : null;
      _selectedWard = null;
      _selectedDate = null;
      _phoneController.clear();
      _orderCodeController.clear();
      _dateController.clear();
      _codRange = RangeValues(
        0,
        math.max(widget.maxCodAmount, 1000000).toDouble(),
      );
    });
    widget.onClear();
  }

  Future<void> _pickDate() async {
    final dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: _selectedDate ?? DateTime.now(),
    );
    if (dateTime == null) return;
    setState(() {
      _selectedDate = dateTime;
      _dateController.text = _formatDate(dateTime);
    });
  }

  String _formatDate(DateTime dateTime) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return "${twoDigits(dateTime.day)}/${twoDigits(dateTime.month)}/${dateTime.year}";
  }
}

class _CompactTextField extends StatelessWidget {
  const _CompactTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.enabled = true,
    this.keyboardType,
    this.suffixIcon,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompactLabel(label),
        const SizedBox(height: AppDimensions.xSmallSpacing),
        SizedBox(
          height: 38,
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.neutral2,
            ),
            decoration: _compactDecoration(
              hintText: hintText,
              enabled: enabled,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactWardDropdown extends StatelessWidget {
  const _CompactWardDropdown({
    required this.label,
    required this.hintText,
    required this.wards,
    required this.selectedWard,
    required this.onSelected,
  });

  final String label;
  final String hintText;
  final List<Ward> wards;
  final Ward? selectedWard;
  final ValueChanged<Ward?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompactLabel(label),
        const SizedBox(height: AppDimensions.xxSmallSpacing),
        DropdownMenu<Ward>(
          initialSelection: selectedWard,
          width: double.maxFinite,
          menuHeight: AppDimensions.dropdownMenuHeight,
          hintText: hintText,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.neutral2,
          ),
          trailingIcon: const Icon(
            Icons.keyboard_arrow_down,
            size: AppDimensions.smallIconSize,
            color: AppColors.neutral5,
          ),
          selectedTrailingIcon: const Icon(
            Icons.keyboard_arrow_up,
            size: AppDimensions.smallIconSize,
            color: AppColors.neutral5,
          ),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: AppDimensions.xxSmallSpacing,
            ),
            hintStyle: _hintStyle,
            border: _compactBorder,
            enabledBorder: _compactBorder,
            focusedBorder: _compactBorder,
          ),
          menuStyle: MenuStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: AppDimensions.xSmallBorderRadius,
              ),
            ),
          ),
          dropdownMenuEntries:
              wards
                  .map(
                    (ward) => DropdownMenuEntry<Ward>(
                      value: ward,
                      label: ward.name,
                    ),
                  )
                  .toList(),
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class _CompactLabel extends StatelessWidget {
  const _CompactLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.neutral2,
      ),
    );
  }
}

class _OrdersHistoryCodRangeField extends StatelessWidget {
  const _OrdersHistoryCodRangeField({
    required this.values,
    required this.maxCodAmount,
    required this.onChanged,
  });

  final RangeValues values;
  final double maxCodAmount;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tiền thu hộ",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral2,
          ),
        ),
        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
        Row(
          children: [
            Text(_formatMoney(values.start), style: AppTextStyles.bodySmall),
            const Spacer(),
            Text(_formatMoney(values.end), style: AppTextStyles.bodySmall),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 1.5,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.neutral8,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.12),
          ),
          child: RangeSlider(
            values: values,
            min: 0,
            max: maxCodAmount,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  String _formatMoney(double value) {
    final amount = value.round();
    final digits = amount.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return "${buffer}đ";
  }
}

InputDecoration _compactDecoration({
  required String hintText,
  required bool enabled,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: _hintStyle,
    filled: true,
    fillColor: enabled ? Colors.white : AppColors.neutral9,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.smallSpacing,
      vertical: AppDimensions.xxSmallSpacing,
    ),
    suffixIcon:
        suffixIcon == null ? null : Center(widthFactor: 1, child: suffixIcon),
    border: _compactBorder,
    enabledBorder: _compactBorder,
    focusedBorder: _compactBorder.copyWith(
      borderSide: const BorderSide(color: AppColors.secondary),
    ),
    disabledBorder: _compactBorder,
  );
}

const TextStyle _hintStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: AppColors.grey400,
);

const OutlineInputBorder _compactBorder = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.neutral7),
  borderRadius: AppDimensions.xSmallBorderRadius,
);
