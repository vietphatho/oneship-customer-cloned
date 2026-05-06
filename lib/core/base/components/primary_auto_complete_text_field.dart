import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/core/themes/app_theme.dart';

class PrimaryAutoCompleteTextField<T> extends StatefulWidget {
  final String? Function(String value)? validator;
  final void Function(T value)? onSelected;
  final Future<List<T>> Function(String keyword) onSearch;
  final String? label;
  final String? hintText;
  final String? instruction;
  final String Function(T item)? displayStringForOption;
  final TextEditingController? controller;
  final FocusNode? node;
  final FocusNode? nextNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign? textAlign;
  final bool enabled;
  final bool isRequired;
  final bool autofocus;
  final int? maxLength;
  final int? maxLine;
  final AutovalidateMode? validateMode;
  final EdgeInsets? paddingInput;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? helper;
  final String? suffixText;
  final Duration debounce;

  const PrimaryAutoCompleteTextField({
    super.key,
    required this.onSearch,
    this.displayStringForOption,
    this.validator,
    this.onSelected,
    this.hintText,
    this.enabled = true,
    this.controller,
    this.label,
    this.paddingInput,
    this.fillColor,
    this.maxLine = 1,
    this.isRequired = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefix,
    this.validateMode,
    this.instruction,
    this.helper,
    this.node,
    this.nextNode,
    this.textInputAction,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign,
    this.keyboardType,
    this.maxLength,
    this.suffixText,
    this.debounce = const Duration(milliseconds: 500),
  });

  @override
  State<PrimaryAutoCompleteTextField<T>> createState() =>
      _PrimaryAutoCompleteTextFieldState<T>();
}

class _PrimaryAutoCompleteTextFieldState<T>
    extends State<PrimaryAutoCompleteTextField<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<T> _options = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  String? _selectedDisplay;
  String? errorText;
  VoidCallback? _controllerListener;

  TextEditingController? get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controllerListener = () {
      if (mounted && errorText != null) {
        setState(() {
          errorText = null;
        });
      }
    };
    _controller?.addListener(_controllerListener!);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _removeOverlay();
    widget.node?.dispose();
    if (_controllerListener != null && _controller != null) {
      _controller!.removeListener(_controllerListener!);
    }
    super.dispose();
  }

  void _onChanged(String value) {
    if (_selectedDisplay != null && value != _selectedDisplay) {
      _selectedDisplay = null;
    }
    _debounceTimer?.cancel();
    if (value.isEmpty) {
      setState(() => _options = []);
      _removeOverlay();
      return;
    }
    _debounceTimer = Timer(widget.debounce, () async {
      setState(() => _isLoading = true);
      final results = await widget.onSearch(value);
      if (mounted) {
        setState(() {
          _options = results;
          _isLoading = false;
        });
        if (_options.isNotEmpty) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      }
    });
  }

  void _showOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 4,
                borderRadius: AppDimensions.largeBorderRadius,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      final item = _options[index];
                      return ListTile(
                        title: Text(
                          widget.displayStringForOption != null
                              ? widget.displayStringForOption!(item)
                              : item.toString(),
                        ),
                        onTap: () {
                          _controller?.text =
                              widget.displayStringForOption?.call(item) ??
                              item.toString();
                          _selectedDisplay = _controller?.text;
                          widget.onSelected?.call(item);
                          setState(() {
                            _options = [];
                          });
                          _removeOverlay();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = AppTheme.getColorScheme(context);
    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: widget.paddingInput ?? EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppDimensions.xSmallSpacing,
                ),
                child: Row(
                  children: [
                    PrimaryText(
                      widget.label,
                      style: AppTextStyles.labelMedium,
                      color: colorScheme.onSurface,
                    ),
                    if (widget.isRequired)
                      PrimaryText(
                        " *",
                        style: AppTextStyles.labelMedium,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: AppDimensions.largeBorderRadius,
              ),
              child: TextFormField(
                textAlign: widget.textAlign ?? TextAlign.left,
                controller: _controller,
                focusNode: widget.node,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                maxLength: widget.maxLength ?? 100,
                maxLines: widget.maxLine,
                keyboardType: widget.keyboardType,
                cursorColor: Colors.black,
                textInputAction: widget.textInputAction,
                textCapitalization: widget.textCapitalization,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontFamily: AppTextStyles.fontFamily,
                ),
                validator: (value) {
                  if (widget.validator == null) return null;
                  final result = widget.validator!(value!);
                  if (mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() => errorText = result);
                    });
                  }
                  return result;
                },
                autovalidateMode:
                    widget.validateMode ?? AutovalidateMode.disabled,
                onChanged: _onChanged,
                onFieldSubmitted: (value) {
                  if (widget.textInputAction == TextInputAction.next) {
                    widget.nextNode?.requestFocus();
                  }
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w300,
                  ),
                  contentPadding: const EdgeInsets.only(
                    left: 14.0,
                    bottom: 14.0,
                    top: 14.0,
                    right: 14,
                  ),
                  helper: widget.helper,
                  filled: true,
                  fillColor: widget.fillColor ?? colorScheme.background,
                  border: _outlineField,
                  enabledBorder: _outlineField,
                  focusedBorder: _outlineField,
                  errorBorder: _outlineField,
                  focusedErrorBorder: _outlineField,
                  disabledBorder: _outlineField,
                  suffixIcon:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                          : widget.suffixIcon,
                  prefixIcon: widget.prefixIcon,
                  prefix: widget.prefix,
                  suffixText: widget.suffixText,
                  errorStyle: const TextStyle(color: Colors.black, fontSize: 0),
                  errorMaxLines: 2,
                ),
                readOnly: false,
                onTap: () {
                  if (_controller?.text.isNotEmpty == true &&
                      _options.isNotEmpty) {
                    _showOverlay();
                  }
                },
              ),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: PrimaryText(errorText, color: AppColors.primary),
              ),
            if (widget.instruction != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: PrimaryText(
                  widget.instruction,
                  color: AppColors.neutral4,
                  style: AppTextStyles.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder get _outlineField {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: errorText == null ? AppColors.neutral7 : AppColors.red500,
      ),
      borderRadius: AppDimensions.largeBorderRadius,
    );
  }
}
