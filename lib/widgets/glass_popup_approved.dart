import 'package:flutter/material.dart';
import 'dart:ui';

class GlassPopup extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onAccept;
  final double? heightPersonalized;
  final double? widthPersonalized;
  final double? fontSizePersonalized;
  final TextAlign? textAlignPersonalized;
  final bool? isExpanded;

  const GlassPopup({
    super.key,
    required this.message,
    this.icon,
    this.onAccept,
    this.heightPersonalized,
    this.widthPersonalized,
    this.fontSizePersonalized,
    this.textAlignPersonalized,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonPadding = EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.1);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            alignment: Alignment.center,
            height: heightPersonalized ?? size.height*0.4,
            width: widthPersonalized ?? size.width*0.35,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black12, Colors.black12],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              padding: EdgeInsets.all(size.width * 0.01),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: size.height * 0.075,
                    color: Colors.white,
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),

                  isExpanded == true ?
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        message,
                        style: TextStyle(fontSize: fontSizePersonalized ?? size.height * 0.035, color: Colors.white, fontFamily: 'Poppins'),
                        textAlign: textAlignPersonalized ?? TextAlign.center,
                      ),
                    ),
                  ):
                  SingleChildScrollView(
                    child: Text(
                      message,
                      style: TextStyle(fontSize: fontSizePersonalized ?? size.height * 0.035, color: Colors.white, fontFamily: 'Poppins'),
                      textAlign: textAlignPersonalized ?? TextAlign.center,
                    ),
                  ),

                  const Divider(
                    color: Colors.transparent,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onAccept?.call();
                    },
                    child: Container(
                      height: size.height * 0.068,
                      padding: buttonPadding,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Continuar',
                        style: TextStyle(color: Colors.white, fontSize: size.height * 0.025),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
