import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/core/themes/app_theme.dart';

class PrimaryTextField extends StatefulWidget {
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

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? helper;

  final String? suffixText;

  const PrimaryTextField({
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
    this.suffixIcon,
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
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool showPass = false;
  String? errorText;
  VoidCallback? _controllerListener;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controllerListener = () {
        if (mounted && errorText != null) {
          setState(() {
            errorText = null;
          });
        }
      };
      widget.controller!.addListener(_controllerListener!);
    }
  }

  @override
  void dispose() {
    widget.node?.dispose();
    // Không dispose focus node thuộc về parent.
    if (_controllerListener != null && widget.controller != null) {
      widget.controller!.removeListener(_controllerListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = AppTheme.getColorScheme(context);

    return Padding(
      padding: widget.paddingInput ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🏷 Label
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
              controller: widget.controller,
              focusNode: widget.node,
              obscureText: widget.obscureText && !showPass,
              obscuringCharacter: "*",
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              maxLength: widget.maxLength ?? 100,
              maxLines: widget.obscureText ? 1 : widget.maxLine,
              keyboardType: widget.keyboardType,
              cursorColor: Colors.black,
              // cursorHeight: TextSize.h4,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontFamily: AppTextStyles.fontFamily,
              ),
              validator: (value) {
                if (widget.validator == null) return null;
                final result = widget.validator!(value!);
                if (mounted && result != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() => errorText = result);
                  });
                }

                return result;
              },
              autovalidateMode:
                  widget.validateMode ?? AutovalidateMode.disabled,
              inputFormatters: widget.inputFormatters,
              onChanged: (value) {
                widget.onChanged?.call(value);
              },
              onFieldSubmitted: (value) {
                if (widget.textInputAction == TextInputAction.next) {
                  widget.nextNode?.requestFocus();
                }
                if (widget.controller != null) {
                  widget.onFieldSubmitted?.call(widget.controller!.text);
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
                  bottom: 8.0,
                  top: 8.0,
                  right: 14,
                ),
                helper: widget.helper,
                filled: true,
                fillColor: widget.fillColor ?? Colors.white,

                /// 🎨 Border
                border: _outlineField,
                enabledBorder: _outlineField,
                focusedBorder: _outlineField,
                errorBorder: _outlineField,
                focusedErrorBorder: _outlineField,
                disabledBorder: _outlineField,

                /// 👁 Hiển thị icon toggle password
                suffixIcon:
                    widget.obscureText
                        ? IconButton(
                          onPressed: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          icon: Icon(
                            showPass
                                ? CupertinoIcons.eye_fill
                                : CupertinoIcons.eye_slash_fill,
                            color: Colors.grey.shade500,
                            size: AppDimensions.smallIconSize,
                          ),
                        )
                        : widget.suffixIcon,
                prefixIcon: widget.prefixIcon,
                prefix: widget.prefix,
                suffixText: widget.suffixText,
                errorStyle: const TextStyle(color: Colors.black, fontSize: 0),
                errorMaxLines: 2,
              ),
            ),
          ),

          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: PrimaryText(
                errorText,
                color: AppColors.primary,
                // size: TextSize.text,
              ),
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
    );
  }

  OutlineInputBorder get _outlineField {
    // bool isDarkMode = AppTheme.isDarkMode(context);

    return OutlineInputBorder(
      borderSide: BorderSide(
        color:
            errorText == null
                // ? isDarkMode
                //     ? AppColors.neutral2
                ? AppColors.neutral7
                : AppColors.red500,
      ),
      borderRadius: AppDimensions.largeBorderRadius,
    );
  }
}
