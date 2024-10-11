import 'package:flutter/material.dart';
import 'dart:ui';

class GlassPopupDisplayInfo extends StatelessWidget {
  final String message;
  final String title;

  const GlassPopupDisplayInfo({super.key, required this.message,required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonPadding = EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.05);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            alignment: Alignment.center,
            height: size.height*0.4,
            width: size.width*0.35,
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: size.height*0.03, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(color: Colors.transparent,),
                  Text(
                    message,
                    style: TextStyle(fontSize: size.height*0.025, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  const Divider(color: Colors.transparent,),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: size.height*0.06,
                      padding: buttonPadding,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Continuar',
                        style: TextStyle(color: Colors.white, fontSize: size.height*0.02),
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
