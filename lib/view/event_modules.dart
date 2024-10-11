import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forms_project/routes/navigation_service.dart';
import 'package:forms_project/themes/app_theme.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:forms_project/widgets/custom_event_card.dart';
import 'package:forms_project/widgets/custom_top_left_buttom.dart';

class EventModulesScreen extends StatefulWidget {
  const EventModulesScreen({super.key});

  @override
  State<EventModulesScreen> createState() => _EventModulesScreenState();
}

class _EventModulesScreenState extends State<EventModulesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();
  late NavigationService navigationService;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void clearInputs() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Scaffold(
          body: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: [
                  Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(gradient: AppTheme().animatedRadialGradient(_controller)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomEventCard(
                          title: "Registrar evento",
                          buttonText: "Registrar ",
                          icon: SvgPicture.asset(
                            'assets/icons/calendar.svg',
                          ),
                          onPressed: () {
                            navigationService.navigateToEventRegister(context);
                          },
                        ),
                        CustomEventCard(
                            title: "Ver lista de eventos",
                            buttonText: "Mostrar",
                            icon: SvgPicture.asset(
                              'assets/icons/event.svg',
                            ),
                            onPressed: () {
                              navigationService.navigateToEventList(context);
                            }),
                        CustomEventCard(
                            title: "Registrar usuarios",
                            buttonText: "Registrar",
                            icon: SvgPicture.asset(
                              'assets/icons/user.svg',
                            ),
                            onPressed: () {
                              navigationService.navigateToEventRegisterUser(context);
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Portal administrador',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.025,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomTopLeftButton(
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      onPressed: () {
                        clearInputs();
                        _secureStorageHelper.storeValue('access_token', '0');
                        _secureStorageHelper.storeValue('role', '0');
                        navigationService.navigateToLogin(context);
                      })
                ],
              );
            },
          ),
        ));
  }
}
