import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/themes/app_theme.dart';

class PrimaryDropdown<T> extends StatelessWidget {
  final List<T> menu;
  final T? initialValue;
  final String Function(T item)? toLabel;
  final ValueChanged<T?>? onSelected;
  final TextEditingController? controller;
  final String hintText;
  final String label;
  final bool isRequired;
  final FormFieldValidator<T>? validator;
  final double paddingMenu;
  final bool requestFocusOnTap;

  const PrimaryDropdown({
    super.key,
    this.controller,
    this.menu = const [],
    this.initialValue,
    this.toLabel,
    this.onSelected,
    this.validator,
    this.hintText = "",
    this.label = "",
    this.isRequired = false,
    this.paddingMenu = AppDimensions.mediumSpacing * 2,
    this.requestFocusOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = AppTheme.getColorScheme(context);

    return FormField<T>(
      initialValue: initialValue,
      validator: validator,
      builder: (FormFieldState<T> state) {
        final hasError = state.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label.isNotEmpty)
              Row(
                children: [
                  PrimaryText(
                    label,
                    style: AppTextStyles.labelMedium,
                    color: hasError ? AppColors.primary : colorScheme.onSurface,
                  ),
                  if (isRequired)
                    const PrimaryText(" *", color: AppColors.primary),
                ],
              ),
            const SizedBox(height: 8),
            DropdownMenu<T>(
              requestFocusOnTap: requestFocusOnTap,
              controller: controller,
              menuHeight: AppDimensions.dropdownMenuHeight,
              width: double.maxFinite,
              enableFilter: true,
              hintText: hintText,
              trailingIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.neutral6,
              ),
              selectedTrailingIcon: const Icon(
                Icons.keyboard_arrow_up,
                color: AppColors.neutral6,
              ),
              textStyle: AppTextStyles.defaultTextStyle,
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(
                  // fontSize: TextSize.p + 1,
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey.shade500,
                ),
                // contentPadding: AppDimensions.mediumPaddingAll,
                filled: true,
                fillColor: colorScheme.surfaceContainerHigh,
                // border: _getBorder(colorScheme),
                enabledBorder: _outlineField,
                focusedBorder: _outlineField,
                errorBorder: _outlineField,
                focusedErrorBorder: _outlineField,
              ),
              // width: AppDimensions.getScreenWidth() - paddingMenu,
              onSelected: (value) {
                state.didChange(value);
                state.validate();
                onSelected?.call(value);
              },
              menuStyle: MenuStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.only(top: 8)),
                elevation: WidgetStateProperty.all(4),
                // backgroundColor: WidgetStateProperty.all(
                //   colorScheme.surfaceContainerHigh,
                // ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              dropdownMenuEntries:
                  menu
                      .map(
                        (e) => DropdownMenuEntry(
                          value: e,
                          label: toLabel?.call(e) ?? e.toString(),
                        ),
                      )
                      .toList(),
            ),

            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: PrimaryText(
                  state.errorText!,
                  color: AppColors.primary,
                  // size: TextSize.text,
                ),
              ),
            // AppSpacing.vertical(AppDimensions.xSmallSpacing),
          ],
        );
      },
    );
  }

  OutlineInputBorder get _outlineField {
    // bool isDarkMode = AppTheme.isDarkMode(context);

    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: AppDimensions.largeBorderRadius,
    );
  }
}
