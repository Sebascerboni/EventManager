import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_project/utils/regex_utils.dart';
import 'package:intl/intl.dart';

class ElegantDateRangePickerFormField extends StatefulWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final TextEditingController? showRange;
  final String labelText;
  final String hintText;
  final String? errorText;
  final Function(bool)? onValidationChanged;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmited;
  final bool? autofocus;
  final DateTime? lastDate;
  final List<TextInputFormatter>? inputFormatters;

  const ElegantDateRangePickerFormField({
    super.key,
    required this.startController,
    required this.endController,
    this.showRange,
    required this.labelText,
    required this.hintText,
    this.errorText,
    this.onValidationChanged,
    this.focusNode,
    this.onFieldSubmited,
    this.autofocus,
    this.lastDate,
    this.inputFormatters,
  });

  @override
  State<ElegantDateRangePickerFormField> createState() => _ElegantDateRangePickerFormFieldState();
}

class _ElegantDateRangePickerFormFieldState extends State<ElegantDateRangePickerFormField> {
  final bool _isFocused = false;
  bool _isHovering = false;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: now, end: now.add(const Duration(days: 7))),
      firstDate: DateTime(now.year - 1),
      lastDate: widget.lastDate ?? DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromRGBO(128, 32, 179, 1),
              onPrimary: Colors.white,
              surface: Colors.black,
            ),
            dialogBackgroundColor: Colors.black,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(128, 32, 179, 1),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
        widget.startController.text = formatter.format(pickedDateRange.start.toLocal());
        widget.endController.text = formatter.format(pickedDateRange.end.toLocal());
        widget.showRange!.text = '${widget.startController.text.split('T')[0]} - ${widget.endController.text.split('T')[0]}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.white;
    const backgroundColor = Colors.transparent;
    const hoverColor = Color.fromRGBO(128, 32, 179, 0.2);

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final paddingVertical = screenHeight * 0.02;
    final paddingHorizontal = screenWidth * 0.0125;
    final borderRadius = screenWidth * 0.008;
    final borderWidth = screenWidth * 0.0007;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: () => _selectDateRange(context),
        child: AbsorbPointer(
          child: TextField(
            controller: widget.showRange,
            focusNode: widget.focusNode,
            onSubmitted: widget.onFieldSubmited,
            inputFormatters: widget.inputFormatters,
            onChanged: (value) {
              bool isValid = RegexUtils.isValidDate(value);
              setState(() {
                widget.onValidationChanged!(isValid);
              });
            },
            style: const TextStyle(
              color: primaryColor,
              fontFamily: 'Poppins',
            ),
            cursorColor: primaryColor,
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: TextStyle(
                color: _isFocused ? primaryColor : primaryColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: mediaQuery.size.height * 0.022,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: primaryColor,
                fontSize: mediaQuery.size.height * 0.022,
              ),
              filled: true,
              fillColor: _isHovering ? hoverColor : backgroundColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: primaryColor, width: borderWidth),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: primaryColor, width: borderWidth),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.red, width: borderWidth),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.red, width: borderWidth),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: paddingVertical,
                horizontal: paddingHorizontal,
              ),
              suffixIcon: const Icon(
                Icons.date_range,
                color: primaryColor,
              ),
              errorText: widget.errorText,
              errorStyle: const TextStyle(color: Colors.red, fontFamily: 'Poppins'),
            ),
          ),
        ),
      ),
    );
  }
}
