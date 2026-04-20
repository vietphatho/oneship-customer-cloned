import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oneship_customer/core/base/components/primary_text_field.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';

class PrimaryDateTimePicker extends StatefulWidget {
  final String? Function(DateTime value)? validator;
  final Function(DateTime value)? onChanged;
  final String? initValue;
  final String? label;
  final String? hintText;
  final String? dateFormat;

  final DateTime? initialDateTime;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final TextEditingController? textEditingController;

  final bool enabled;
  final bool isRequired;

  final AutovalidateMode? validateMode;

  const PrimaryDateTimePicker({
    super.key,
    this.validator,
    this.hintText,
    this.enabled = true,
    this.textEditingController,
    this.onChanged,
    this.label,
    this.isRequired = false,
    this.validateMode,
    this.initialDateTime,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.initValue,
  });

  @override
  State<PrimaryDateTimePicker> createState() => _PrimaryDateTimePickerState();
}

class _PrimaryDateTimePickerState extends State<PrimaryDateTimePicker> {
  final _controller = TextEditingController();
  late DateFormat _dateFormat;
  DateTime? result;

  @override
  void initState() {
    _dateFormat = DateFormat(widget.dateFormat ?? Constants.defaultDateFormat);
    if (widget.initialDateTime != null) {
      var dateFormatted = _dateFormat.format(widget.initialDateTime!);
      _controller.text = dateFormatted;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          firstDate: widget.firstDate ?? DateTimeUtils.minDate,
          lastDate: widget.lastDate ?? DateTimeUtils.maxDate,
          initialDate: widget.initialDateTime ?? result,
          // currentDate: DateTime.now(),
        ).then((dateTime) {
          if (dateTime == null) return;
          result = dateTime;
          _controller.text = DateFormat(
            widget.dateFormat ?? Constants.defaultDateFormat,
          ).format(dateTime);
          widget.onChanged?.call(dateTime);
        });
      },
      child: AbsorbPointer(
        child: PrimaryTextField(
          validator: (dateString) {
            if (result == null) return null;
            return widget.validator?.call(result!);
          },
          isRequired: widget.isRequired,
          label: widget.label,
          hintText: widget.hintText,
          controller: _controller,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(AppDimensions.smallSpacing),
            child: SvgPicture.asset("assets/icons/ic_calendar.svg"),
          ),
        ),
      ),
    );
  }
}
