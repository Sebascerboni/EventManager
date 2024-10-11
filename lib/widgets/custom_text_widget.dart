import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;

  const CustomTextWidget({
    super.key,
    required this.text,

  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Text(
      text,
      style: TextStyle(
        fontSize: size.height * 0.022,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    );
  }
}
