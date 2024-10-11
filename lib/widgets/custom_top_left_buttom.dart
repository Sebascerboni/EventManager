import 'package:flutter/material.dart';

class CustomTopLeftButton extends StatelessWidget {
  final double? topOffset;
  final double? leftOffset;
  final IconData icon;
  final String? text;

  final Function onPressed;

  const CustomTopLeftButton({
    super.key,
    this.topOffset,
    this.leftOffset,
    required this.icon,
    required this.onPressed,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      left: size.height * 0.066,
      top: size.height * 0.066,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width * 0.8),
          color: Colors.transparent,
        ),
        child: InkWell(
          onTap: () async {
            await onPressed();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(width: size.width * 0.004),
              Text(
                text ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.01,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(width: size.width * 0.004),
            ],
          ),
        ),
      ),
    );
  }
}
