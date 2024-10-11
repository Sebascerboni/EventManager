import 'package:flutter/material.dart';

class ElegantCustomBoolSwitch extends StatefulWidget {
  final String? labelText;
  final String option1;
  final String option2;
  final bool defaultValue;
  final ValueChanged<bool> onChanged;

  const ElegantCustomBoolSwitch({
    super.key,
    this.labelText,
    required this.option1,
    required this.option2,
    required this.defaultValue,
    required this.onChanged,
  });

  @override
  ElegantCustomBoolSwitchState createState() =>
      ElegantCustomBoolSwitchState();
}

class ElegantCustomBoolSwitchState extends State<ElegantCustomBoolSwitch>
    with SingleTickerProviderStateMixin {
  late bool _statusActive; // Determina cuál opción está activa
  late AnimationController _animationController;

  // ignore: unused_field
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _statusActive = widget.defaultValue; // Configura el estado inicial basado en defaultValue
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0), // Desplazamiento de la animación del círculo
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant ElegantCustomBoolSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultValue != widget.defaultValue) {
      setState(() {
        _statusActive = widget.defaultValue;
        _updateAnimation();
      });
    }
  }

  void _updateAnimation() {
    if (_statusActive) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(128, 32, 179, 1);
    final Color inactiveButtonColor = primaryColor.withOpacity(0.65);
    const Color inactiveColor = Colors.white;
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: size.height * 0.022,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        SizedBox(width: size.width * 0.005),
        GestureDetector(
          onTap: () {
            setState(() {
              _statusActive = !_statusActive; // Cambia el estado entre true y false
              _updateAnimation();
              // Actualiza el valor booleano
              widget.onChanged(_statusActive);
            });
          },
          child: Container(
            height: size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.width * 0.008),
              color: Colors.black,
            ),
            child: Row(
              children: [
                // Opción 1
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: _statusActive ? size.width * 0.085 : size.width * 0.075,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                    color: _statusActive ? primaryColor : inactiveButtonColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.width * 0.008),
                        bottomLeft: Radius.circular(size.width * 0.008)),
                    boxShadow: _statusActive
                        ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        spreadRadius: 1.5,
                        blurRadius: 4,
                      ),
                    ]
                        : [],
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        widget.option1,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: size.height * 0.022,
                          color: _statusActive ? Colors.white : inactiveColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: !_statusActive ? size.width * 0.085 : size.width * 0.075,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                    color: !_statusActive ? primaryColor : inactiveButtonColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(size.width * 0.008),
                        bottomRight: Radius.circular(size.width * 0.008)),
                    boxShadow: !_statusActive
                        ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ]
                        : [],
                  ),
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          widget.option2,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: size.height * 0.022,
                            color: !_statusActive ? Colors.white : inactiveColor,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
