import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/filter_dropdown.dart';
import 'package:oneship_customer/core/base/components/filter_text_field.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';

/// Filter data model for the processing orders filter panel.
class ProcessingOrdersFilters {
  const ProcessingOrdersFilters({
    this.orderCode = '',
    this.zone = '',
    this.phone = '',
    this.province,
    this.ward,
    this.fromDate,
    this.toDate,
  });

  final String orderCode;
  final String zone;
  final String phone;
  final Province? province;
  final Ward? ward;
  final DateTime? fromDate;
  final DateTime? toDate;

  factory ProcessingOrdersFilters.empty() => const ProcessingOrdersFilters();

  bool get isEmpty =>
      orderCode.isEmpty &&
      zone.isEmpty &&
      phone.isEmpty &&
      province == null &&
      ward == null &&
      fromDate == null &&
      toDate == null;

  ProcessingOrdersFilters copyWith({
    String? orderCode,
    String? zone,
    String? phone,
    Province? province,
    Ward? ward,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearProvince = false,
    bool clearWard = false,
    bool clearFromDate = false,
    bool clearToDate = false,
  }) {
    return ProcessingOrdersFilters(
      orderCode: orderCode ?? this.orderCode,
      zone: zone ?? this.zone,
      phone: phone ?? this.phone,
      province: clearProvince ? null : (province ?? this.province),
      ward: clearWard ? null : (ward ?? this.ward),
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
    );
  }
}

/// Filter panel for processing orders page.
/// Displays a collapsible filter section with order code, zone, phone,
/// province/ward selectors, date range pickers, and action buttons.
class ProcessingOrdersFilterPanel extends StatefulWidget {
  const ProcessingOrdersFilterPanel({
    super.key,
    required this.initialFilters,
    required this.onApply,
    required this.onReset,
    this.onExportExcel,
  });

  final ProcessingOrdersFilters initialFilters;
  final ValueChanged<ProcessingOrdersFilters> onApply;
  final VoidCallback onReset;
  final VoidCallback? onExportExcel;

  @override
  State<ProcessingOrdersFilterPanel> createState() =>
      _ProcessingOrdersFilterPanelState();
}

class _ProcessingOrdersFilterPanelState
    extends State<ProcessingOrdersFilterPanel> {
  final _orderCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();

  List<Province> _provinces = const [];
  Map<String, List<Ward>> _wardsByProvince = const {};
  Province? _selectedProvince;
  Ward? _selectedWard;
  DateTime? _fromDate;
  DateTime? _toDate;

  List<Ward> get _wards {
    if (_selectedProvince == null) return const [];
    return _wardsByProvince[_selectedProvince!.code.toString()] ?? const [];
  }

  @override
  void initState() {
    super.initState();
    _orderCodeController.text = widget.initialFilters.orderCode;
    _phoneController.text = widget.initialFilters.phone;
    _selectedProvince = widget.initialFilters.province;
    _selectedWard = widget.initialFilters.ward;
    _fromDate = widget.initialFilters.fromDate;
    _toDate = widget.initialFilters.toDate;
    if (_fromDate != null) _fromDateController.text = _formatDate(_fromDate!);
    if (_toDate != null) _toDateController.text = _formatDate(_toDate!);
    _loadRegions();
  }

  @override
  void dispose() {
    _orderCodeController.dispose();
    _phoneController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Mã đơn hàng + Khu vực
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.smallSpacing,
              AppDimensions.smallSpacing,
              AppDimensions.smallSpacing,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: FilterTextField(
                    label: 'order_code'.tr(),
                    hintText: 'input'.tr(),
                    controller: _orderCodeController,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: AppDimensions.xSmallIconSize,
                      color: AppColors.neutral5,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.xSmallSpacing),
                Expanded(
                  child: FilterDropdown<Province>(
                    label: 'zone'.tr(),
                    hintText: 'select_zone'.tr(),
                    value: _selectedProvince,
                    items: _provinces,
                    itemLabel: (p) => p.name,
                    onChanged: (p) {
                      setState(() {
                        _selectedProvince = p;
                        _selectedWard = null;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Row 2: Số điện thoại
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.smallSpacing,
              AppDimensions.xSmallSpacing,
              AppDimensions.smallSpacing,
              0,
            ),
            child: FilterTextField(
              label: 'phone_number'.tr(),
              hintText: 'input'.tr(),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
          ),
          // Row 3: Tỉnh/Thành + Phường/Xã
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.smallSpacing,
              AppDimensions.xSmallSpacing,
              AppDimensions.smallSpacing,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: FilterDropdown<Province>(
                    label: 'province'.tr(),
                    hintText: 'select_province_city'.tr(),
                    value: _selectedProvince,
                    items: _provinces,
                    itemLabel: (p) => p.name,
                    onChanged: (p) {
                      setState(() {
                        _selectedProvince = p;
                        _selectedWard = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.xSmallSpacing),
                Expanded(
                  child: FilterDropdown<Ward>(
                    label: 'ward'.tr(),
                    hintText: 'select_ward_commune'.tr(),
                    value: _selectedWard,
                    items: _wards,
                    itemLabel: (w) => w.name,
                    onChanged: (w) {
                      setState(() => _selectedWard = w);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Row 4: Từ ngày + Đến ngày
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.smallSpacing,
              AppDimensions.xSmallSpacing,
              AppDimensions.smallSpacing,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(isFromDate: true),
                    child: AbsorbPointer(
                      child: FilterTextField(
                        label: 'from_date'.tr(),
                        hintText: 'select_date'.tr(),
                        controller: _fromDateController,
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: AppDimensions.xSmallIconSize,
                          color: AppColors.neutral5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.xSmallSpacing),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(isFromDate: false),
                    child: AbsorbPointer(
                      child: FilterTextField(
                        label: 'to_date'.tr(),
                        hintText: 'select_date'.tr(),
                        controller: _toDateController,
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: AppDimensions.xSmallIconSize,
                          color: AppColors.neutral5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action buttons: Đặt lại | Áp dụng | Xuất Excel
          Padding(
            padding: const EdgeInsets.all(AppDimensions.smallSpacing),
            child: Row(
              children: [
                // Đặt lại
                OutlinedButton(
                  onPressed: _onReset,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.smallSpacing,
                      vertical: AppDimensions.xxSmallSpacing,
                    ),
                    side: const BorderSide(color: AppColors.neutral6),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDimensions.xSmallBorderRadius,
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                  child: Text(
                    'reset'.tr(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutral4,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.xxSmallSpacing),
                // Áp dụng
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: _onApply,
                      icon: const Icon(
                        Icons.filter_list_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      label: Text(
                        'filter_result'.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDimensions.xSmallBorderRadius,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.xSmallSpacing,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.xxSmallSpacing),
                // Xuất Excel
                SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    onPressed: widget.onExportExcel,
                    icon: const Icon(
                      Icons.file_download_outlined,
                      size: 14,
                      color: AppColors.green,
                    ),
                    label: Text(
                      'export_excel'.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDimensions.xSmallBorderRadius,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.xSmallSpacing,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadRegions() async {
    try {
      final provinceStr =
          await rootBundle.loadString('assets/json/provinces.json');
      final provinceJson = jsonDecode(provinceStr) as List;
      final provinces = provinceJson.map((e) => Province.fromJson(e)).toList();

      final wardStr = await rootBundle.loadString('assets/json/wards.json');
      final wardJson = jsonDecode(wardStr) as List;
      final wards = wardJson.map((e) => Ward.fromJson(e)).toList();

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
      });
    } catch (_) {
      // If assets not available, proceed without data
    }
  }

  Future<void> _pickDate({required bool isFromDate}) async {
    final initial = isFromDate ? _fromDate : _toDate;
    final firstDate = isFromDate ? DateTime(2020) : (_fromDate ?? DateTime(2020));
    final lastDate =
        isFromDate ? (_toDate ?? DateTime(2100)) : DateTime(2100);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null) return;
    setState(() {
      if (isFromDate) {
        _fromDate = picked;
        _fromDateController.text = _formatDate(picked);
      } else {
        _toDate = picked;
        _toDateController.text = _formatDate(picked);
      }
    });
  }

  void _onApply() {
    widget.onApply(
      ProcessingOrdersFilters(
        orderCode: _orderCodeController.text.trim(),
        phone: _phoneController.text.trim(),
        province: _selectedProvince,
        ward: _selectedWard,
        fromDate: _fromDate,
        toDate: _toDate,
      ),
    );
  }

  void _onReset() {
    setState(() {
      _orderCodeController.clear();
      _phoneController.clear();
      _selectedProvince = null;
      _selectedWard = null;
      _fromDate = null;
      _toDate = null;
      _fromDateController.clear();
      _toDateController.clear();
    });
    widget.onReset();
  }

  String _formatDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}';
  }
}


