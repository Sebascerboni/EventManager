import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_project/routes/navigation_service.dart';
import 'package:forms_project/themes/app_theme.dart';
import 'package:forms_project/widgets/custom_animated_container.dart';
import 'package:provider/provider.dart';
import '../viewmodel/login/ilogin_viewmodel.dart';
import '../widgets/custom_input_text_fiel_widget.dart';
import '../widgets/glass_popup_approved.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late NavigationService navigationService;
  late AnimationController _controller;

  // late AnimationController _easterEggController;
  late AnimationController _flipController;
  bool _isFlipped = false;

  final FocusNode _focusNodeInputUser = FocusNode();
  final FocusNode _focusNodeInputPassword = FocusNode();

  final TextEditingController adminClient = TextEditingController();
  final TextEditingController passwordClient = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Controlador para la animación principal
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    _flipController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // _flipController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _flipSection() {
    setState(() {
      _isFlipped = !_isFlipped;
      if (_isFlipped) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final size = MediaQuery.of(context).size;
              return Container(
                height: size.height,
                decoration: BoxDecoration(
                  gradient: AppTheme().animatedRadialGradient(_controller),
                ),
                child: AnimatedBuilder(
                  animation: _flipController,
                  builder: (context, child) {
                    double rotationValue = _flipController.value * math.pi;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(rotationValue),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.15),
                        child: rotationValue < math.pi / 2
                            ? Row(
                                children: [
                                  Container(
                                    width: size.width * 0.35,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(size.width * 0.008 * 2.5),
                                        bottomLeft: Radius.circular(size.width * 0.008 * 2.5),
                                      ),
                                    ),
                                    child: loginInputs(),
                                  ),
                                  Container(
                                    width: size.width * 0.45,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 28, 28, 28),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(size.height * 0.05),
                                        bottomRight: Radius.circular(size.height * 0.05),
                                      ),
                                    ),
                                    child: psfContainer(),
                                  ),
                                ],
                              )
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(math.pi),
                                child: Center(
                                  child: Text(
                                    """
 Desarrollado por:
                                    
               - Dennis David Lincango Simbaña (Frontend) 
               - Guillermo Sebastián Cervantes Bonilla (Frontend)
               - Jhonattan Steven Amagua Taco (Backend) 
               - Kevin Alexander Macas Hoyos (QA y documentación)
               - Thomas Fabricio Tapia Boada (QA)
                                    """,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: size.width * 0.015,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // Área superior derecha para interactuar y hacer el flip
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: _flipSection,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.15, // Haz que el área de toque sea más grande
                height: MediaQuery.of(context).size.height * 0.1, // Más alta para ser más fácil de seleccionar
                color: Colors.transparent, // Mantén el contenedor transparente
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    final loginViewModel = Provider.of<ILoginViewModel>(context, listen: false);
    loginViewModel.login(context, adminClient.text, passwordClient.text).then((_) {
      adminClient.clear();
      passwordClient.clear();
    }).catchError((e) {
      if (!mounted) return;
      _showPopup(context, false, e.toString());
      adminClient.clear();
      passwordClient.clear();
    });
  }

  Widget loginInputs() {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.width * 0.025, horizontal: size.height * 0.05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenido',
                style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: size.height * 0.075),
              ),
              Text(
                '¡Tu evento perfecto, tu experiencia ideal!',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: size.height * 0.025),
              ),
              SizedBox(
                width: size.width * 0.175,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: ElegantTextField(
                    focusNode: _focusNodeInputUser,
                    onFieldSubmitted: (value) => _focusNodeInputPassword.requestFocus(),
                    mainColor: const Color.fromRGBO(128, 32, 179, 1),
                    controller: adminClient,
                    labelText: 'Usuario',
                    hintText: 'Ingrese su usuario',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ_-]')),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.175,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: ElegantTextField(
                    mainColor: const Color.fromRGBO(128, 32, 179, 1),
                    obscureText: true,
                    focusNode: _focusNodeInputPassword,
                    controller: passwordClient,
                    labelText: 'Contraseña',
                    hintText: 'Ingrese su contraseña',
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.03),
                    child: Consumer<ILoginViewModel>(
                      builder: (context, loginViewModel, child) {
                        return loginViewModel.isLoading
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: _handleLogin,
                                child: CustomAnimatedContainer(
                                  width: size.width * 0.175,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(79, 20, 107, 1.0),
                                    borderRadius: BorderRadius.circular(size.width * 0.008),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Iniciar sesión',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget psfContainer() {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppTheme().animatedRadialGradientSecondary(_controller),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(size.width * 0.008 * 2.5),
              bottomRight: Radius.circular(size.width * 0.008 * 2.5),
            ),
          ),
          child: Center(
            child: Container(
              height: size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.height * 0.05),
              ),
              child: Image.asset('assets/images/PSF_Black_Title_Shadow.png'),
            ),
          ),
        );
      },
    );
  }

  void _showPopup(BuildContext context, bool isSuccess, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassPopup(
          icon: isSuccess ? Icons.check_circle : Icons.warning,
          message: isSuccess ? 'Ingreso exitoso' : message,
        );
      },
    );
  }
}
