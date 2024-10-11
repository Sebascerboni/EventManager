import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final String labelText;
  final String? secondaryText;
  final void Function(bool?) onTap;
  final void Function()? onTapText;

  const CustomCheckBox({
    super.key,
    required this.isChecked,
    required this.labelText,
    this.secondaryText,
    required this.onTap,
    this.onTapText,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.25,
      child: AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: RoundCheckBox(
                isRound: true,
                onTap: onTap,
                size: size.height * 0.022,
                checkedColor: const Color(0xff006d5f),
                isChecked: isChecked,
                checkedWidget:  Icon(Icons.check,
                  size: size.height * 0.016,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.008),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: labelText,
                      style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: size.height * 0.018),
                    ),
                    TextSpan(
                      text: secondaryText,
                      style: TextStyle(color: Colors.blueAccent, fontFamily: 'Poppins', fontSize: size.height * 0.018),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => onTapText?.call(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
