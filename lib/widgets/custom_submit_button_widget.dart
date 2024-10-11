import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final List<TextEditingController>? controllers;
  final bool? validateEventForm;
  final VoidCallback onPressed;
  final Color? backgroundColor; // Color de fondo opcional
  final Color? textColor;
  final String? buttonText;// Color de texto opcional

  const SubmitButton({super.key, 
    this.controllers,
    this.validateEventForm,
    required this.onPressed,
    this.backgroundColor, // Se puede pasar color de fondo
    this.textColor,
    this.buttonText// Se puede pasar color de texto
  });

  @override
  Widget build(BuildContext context) {
    bool isFormValid = validateEventForm == true && controllers!.every((controller) => controller.text.isNotEmpty);
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: isFormValid ? onPressed : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isFormValid
              ? (backgroundColor ?? const Color.fromRGBO(79, 20, 107, 1.0)) // Usa el color de fondo opcional o el predeterminado
              : const Color.fromRGBO(47, 79, 79, 0.363),
          borderRadius: BorderRadius.circular(size.width * 0.008),
        ),
        child: Center(
          child: Text(
            buttonText ?? 'Subir Formulario',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: size.height * 0.022,
              color: textColor ?? Colors.white,
              fontFamily: 'Poppins',
              // Usa el color de texto opcional o el predeterminado
            ),
          ),
        ),
      ),
    );
  }
}
