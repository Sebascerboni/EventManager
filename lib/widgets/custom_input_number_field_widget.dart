import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ElegantNumberField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final Color mainColor;
  final String? errorText; // Mensaje de error opcional
  final ValueChanged<String>? onChanged; // Función opcional para onChanged
  final FormFieldValidator<String>? validator; // Función opcional para validator
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmited;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;

  const ElegantNumberField({
    super.key,
    this.controller,
    required this.labelText,
    required this.hintText,
    required this.mainColor,
    this.errorText,
    this.onChanged, // Inicializar el nuevo parámetro
    this.validator, // Inicializar el nuevo parámetro
    this.focusNode,
    this.onFieldSubmited,
    this.autofocus,
    this.inputFormatters,
  });

  @override
  ElegantNumberFieldState createState() => ElegantNumberFieldState();
}

class ElegantNumberFieldState extends State<ElegantNumberField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final primaryColor = widget.mainColor;
    final secondaryColor = widget.mainColor;
    const backgroundColor = Colors.transparent;
    final hintTextColor = widget.mainColor;

    final borderRadius = screenWidth * 0.008;
    final borderWidth = screenWidth * 0.0007;
    final paddingVertical = screenHeight * 0.02;
    final paddingHorizontal = screenWidth * 0.0125;
    final size = MediaQuery.of(context).size;

    return Theme(
      data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor:  Colors.grey,
          )
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onFieldSubmited,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: size.height * 0.022,
          color: secondaryColor,
          fontFamily: 'Poppins',
        ),
        cursorColor: primaryColor,
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: widget.inputFormatters ?? [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          DecimalTextInputFormatter(decimalRange: 2),
        ],
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: _isFocused ? primaryColor : hintTextColor,
            fontFamily: 'Poppins',
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
            fontSize:  size.height * 0.022,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: hintTextColor,
            fontFamily: 'Poppins',
            overflow: TextOverflow.ellipsis,
            fontStyle: FontStyle.italic,
            fontSize:  size.height * 0.022,
          ),
          filled: true,
          fillColor: backgroundColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: hintTextColor, width: borderWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: primaryColor, width: borderWidth * 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red, width: borderWidth),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red, width: borderWidth * 3),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: paddingVertical,
            horizontal: paddingHorizontal,
          ),
          errorText: widget.errorText,
          errorStyle: TextStyle(color: Colors.red, fontFamily: 'Poppins', overflow: TextOverflow.ellipsis, fontSize: size.height * 0.022),
        ),
        onChanged: (text) {
          // Llamar a la función onChanged si se ha proporcionado
          if (widget.onChanged != null) {
            widget.onChanged!(text);
          }
          setState(() {});
        },
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        validator: widget.validator, // Usar el validador proporcionado si existe
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text == '') return newValue;

    final newText = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$').stringMatch(text);

    if (newText == null) {
      return oldValue;
    }

    return newValue.copyWith(text: newText);
  }
}