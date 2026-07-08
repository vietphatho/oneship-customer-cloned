import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/entities/barcode_scan_result.dart';
import 'package:oneship_customer/features/barcode_scanner/presentation/widgets/reusable_barcode_scanner_view.dart';

class PrimaryScannableTextField extends StatefulWidget {
  const PrimaryScannableTextField({
    super.key,
    this.validator,
    this.hintText,
    this.enabled = true,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.textAlign,
    this.maxLength,
    this.obscureText = false,
    this.autofocus = false,
    this.label,
    this.paddingInput,
    this.fillColor,
    this.maxLine = 1,
    this.isRequired = false,
    this.enabledText,
    this.prefixIcon,
    this.prefix,
    this.validateMode,
    this.instruction,
    this.inputFormatters,
    this.helper,
    this.node,
    this.nextNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.suffixText,
    this.scanTitle,
    this.scanInstructionText,
    this.scanButtonTooltip,
  });

  final String? Function(String value)? validator;
  final Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;

  final String? label;
  final String? hintText;
  final String? instruction;

  final TextEditingController? controller;

  final FocusNode? node;
  final FocusNode? nextNode;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  final TextAlign? textAlign;
  final bool enabled;
  final bool obscureText;
  final bool isRequired;
  final bool? enabledText;
  final bool autofocus;
  final int? maxLength;
  final int? maxLine;
  final AutovalidateMode? validateMode;
  final EdgeInsets? paddingInput;
  final Color? fillColor;

  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? helper;

  final String? suffixText;

  final String? scanTitle;
  final String? scanInstructionText;
  final String? scanButtonTooltip;

  @override
  State<PrimaryScannableTextField> createState() =>
      _PrimaryScannableTextFieldState();
}

class _PrimaryScannableTextFieldState extends State<PrimaryScannableTextField> {
  late TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      validator: widget.validator,
      hintText: widget.hintText,
      enabled: widget.enabled,
      controller: _effectiveController,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textAlign: widget.textAlign,
      maxLength: widget.maxLength,
      obscureText: widget.obscureText,
      autofocus: widget.autofocus,
      label: widget.label,
      paddingInput: widget.paddingInput,
      fillColor: widget.fillColor,
      maxLine: widget.maxLine,
      isRequired: widget.isRequired,
      enabledText: widget.enabledText,
      prefixIcon: widget.prefixIcon,
      prefix: widget.prefix,
      validateMode: widget.validateMode,
      instruction: widget.instruction,
      inputFormatters: widget.inputFormatters,
      helper: widget.helper,
      node: widget.node,
      nextNode: widget.nextNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      textCapitalization: widget.textCapitalization,
      suffixText: widget.suffixText,
      suffixIcon: IconButton(
        icon: const Icon(
          Icons.qr_code_scanner_rounded,
          color: AppColors.primary,
          size: AppDimensions.smallIconSize,
        ),
        tooltip:
            widget.scanButtonTooltip ??
            'primary_scannable_text_field.scan'.tr(),
        onPressed: widget.enabled ? _openScanner : null,
      ),
    );
  }

  Future<void> _openScanner() async {
    widget.node?.unfocus();
    final scannedValue = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => _PrimaryScannableTextFieldScannerPage(
          title: widget.scanTitle ?? 'primary_scannable_text_field.title'.tr(),
          instructionText:
              widget.scanInstructionText ??
              'primary_scannable_text_field.instruction'.tr(),
        ),
      ),
    );

    final nextValue = scannedValue?.trim();
    if (!mounted || nextValue == null || nextValue.isEmpty) return;

    _effectiveController.text = nextValue;
    _effectiveController.selection = TextSelection.collapsed(
      offset: nextValue.length,
    );
    widget.onChanged?.call(nextValue);

    if (widget.validateMode != null &&
        widget.validateMode != AutovalidateMode.disabled) {
      Form.maybeOf(context)?.validate();
    }

    if (widget.textInputAction == TextInputAction.next) {
      widget.nextNode?.requestFocus();
    }
    widget.onFieldSubmitted?.call(nextValue);
  }
}

class _PrimaryScannableTextFieldScannerPage extends StatefulWidget {
  const _PrimaryScannableTextFieldScannerPage({
    required this.title,
    required this.instructionText,
  });

  final String title;
  final String instructionText;

  @override
  State<_PrimaryScannableTextFieldScannerPage> createState() =>
      _PrimaryScannableTextFieldScannerPageState();
}

class _PrimaryScannableTextFieldScannerPageState
    extends State<_PrimaryScannableTextFieldScannerPage> {
  bool _isClosing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral1,
      appBar: PrimaryAppBar(
        title: widget.title,
        backgroundColor: AppColors.neutral1,
        titleColor: AppColors.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.onPrimary),
          tooltip: 'close'.tr(),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ReusableBarcodeScannerView(
          isProcessing: _isClosing,
          instructionText: widget.instructionText,
          processingText: 'loading'.tr(),
          permissionDeniedText: 'primary_scannable_text_field.camera_error'
              .tr(),
          openSettingsText: 'open_settings'.tr(),
          retryText: 'retry'.tr(),
          onBarcodeDetected: _handleBarcodeDetected,
          onScannerError: _handleScannerError,
        ),
      ),
    );
  }

  void _handleBarcodeDetected(BarcodeScanResult result) {
    if (_isClosing) return;

    setState(() => _isClosing = true);
    Navigator.of(context).pop(result.code);
  }

  void _handleScannerError(Object error) {
    if (!mounted) return;
    PrimaryDialog.showErrorDialog(
      context,
      message: 'primary_scannable_text_field.camera_error',
    );
  }
}
