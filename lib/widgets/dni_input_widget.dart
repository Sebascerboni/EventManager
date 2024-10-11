import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DNIField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Color mainColor;
  final bool isCedula;
  final Function(String)? onChanged;
  final bool? readOnly;
  final ValueChanged<String>? onFieldSubmited;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;


  const DNIField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.mainColor,
    required this.isCedula,
    this.onChanged,
    this.readOnly,
    this.onFieldSubmited,
    this.autofocus,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  DNIFieldState createState() => DNIFieldState();
}

class DNIFieldState extends State<DNIField> {
  String? _errorText;

  bool _isValidDocument(String value) {
    if (widget.isCedula) {
      return value.length == 10 && _validarCedulaEcuatoriana(value);
    } else {
      return value.isNotEmpty && value.length >= 6 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
    }
  }

  bool _validarCedulaEcuatoriana(String cedula) {
    if (cedula.length != 10) return false;
    final provincia = int.parse(cedula.substring(0, 2));
    if (provincia < 1 || provincia > 24) return false;
    final coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
    int suma = 0;
    for (int i = 0; i < 9; i++) {
      int valor = int.parse(cedula[i]) * coeficientes[i];
      suma += valor >= 10 ? valor - 9 : valor;
    }
    int digitoVerificador = (10 - (suma % 10)) % 10;
    return digitoVerificador == int.parse(cedula[9]);
  }

  @override
Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final screenHeight = mediaQuery.size.height;
  final screenWidth = mediaQuery.size.width;

  final primaryColor = widget.mainColor;
  final hintTextColor = widget.mainColor;

  final borderRadius = screenWidth * 0.008;
  final borderWidth = screenWidth * 0.0007;
  final paddingVertical = screenHeight * 0.02;
  final paddingHorizontal = screenWidth * 0.0125;

  return TextField(
    controller: widget.controller,
    maxLengthEnforcement: MaxLengthEnforcement.none, // Desactiva el contador de caracteres
    readOnly: widget.readOnly ?? false,
    onChanged: (value) {
      if (value.length == 10 || !widget.isCedula) {
        setState(() {
          _errorText = _isValidDocument(value) ? null : 'Número de documento inválido';
        });

        if (_errorText == null && widget.onChanged != null) {
          widget.onChanged!(value);
        }
      } else if (widget.isCedula) {
        setState(() {
          _errorText = null;
        });
      }
    },
      focusNode: widget.focusNode,
    keyboardType: widget.isCedula ? TextInputType.number : TextInputType.text,
    inputFormatters: widget.isCedula
        ? [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ]
        : [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
    style: TextStyle(
      fontSize: screenHeight * 0.022,
      color: primaryColor,
      fontFamily: 'Poppins',
    ),
    cursorColor: primaryColor,
    decoration: InputDecoration(
      labelText: widget.labelText,
      labelStyle: TextStyle(
        color: primaryColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      hintText: widget.hintText,
      hintStyle: TextStyle(
        fontSize: screenHeight * 0.022,
        color: hintTextColor,
        fontFamily: 'Poppins',
        fontStyle: FontStyle.italic,
      ),
      filled: true,
      fillColor: Colors.transparent,
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
      errorText: _errorText,
      errorStyle: const TextStyle(color: Colors.red, fontFamily: 'Poppins'),
    ),
  );
}

}