import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_project/utils/regex_utils.dart';

class ElegantDatePickerFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? errorText;
  final Function(bool) onValidationChanged;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmited;
  final bool? autofocus;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final List<TextInputFormatter>? inputFormatters;
  final DateTime? initialDate;

  const ElegantDatePickerFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.errorText,
    required this.onValidationChanged,
    this.focusNode,
    this.onFieldSubmited,
    this.autofocus,
    this.lastDate,
    this.firstDate,
    this.initialDate,
    this.inputFormatters,
  });

  @override
  ElegantDatePickerFormFieldState createState() => ElegantDatePickerFormFieldState();
}

class ElegantDatePickerFormFieldState extends State<ElegantDatePickerFormField> {
  final bool _isFocused = false;
  bool _isHovering = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true, // Asegura que el BottomSheet se ajuste al contenido
      builder: (BuildContext context) {
        DateTime selectedDate = DateTime.now();
        final mediaQuery = MediaQuery.of(context);
        final screenHeight = mediaQuery.size.height;
        final screenWidth = mediaQuery.size.width;
        final radius = screenWidth * 0.008;
        final buttonHeight = screenHeight * 0.06;
        DateTime? lastDate = widget.lastDate;
        DateTime? initialDate = widget.initialDate;
        DateTime? firstDate = widget.firstDate;
        final size = MediaQuery.of(context).size;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[900],
              borderRadius:   BorderRadius.circular(size.width * 0.03),
            ),
            child: Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color.fromRGBO(128, 32, 179, 1),
                  onPrimary: Colors.white,
                ),
                dialogBackgroundColor: Colors.black,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(128, 32, 179, 1),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(size.width * 0.008),
                          topRight: Radius.circular(size.width * 0.008),
                        )
                      ),
                      child: CalendarDatePicker(
                        initialDate: initialDate ?? DateTime.now(),
                        firstDate: firstDate ?? DateTime(DateTime.now().year - 1),
                        lastDate: lastDate ?? DateTime(DateTime.now().year + 10),
                        onDateChanged: (DateTime date) {
                          selectedDate = date;
                        },
                        selectableDayPredicate: (DateTime day) {
                          return true;
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, selectedDate);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(128, 32, 179, 1),
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        height: buttonHeight,
                        child: const Center(
                          child: Text(
                            'Seleccionar',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        widget.controller.text = "${pickedDate.toLocal()}".split(' ')[0];
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
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onSubmitted: widget.onFieldSubmited,
            inputFormatters: widget.inputFormatters,
            onChanged: (value) {
              bool isValid = RegexUtils.isValidDate(value);
             setState(() {
               widget.onValidationChanged(isValid);
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
                Icons.arrow_drop_down,
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
