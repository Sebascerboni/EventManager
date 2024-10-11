import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forms_project/routes/navigation_service.dart';
import 'package:forms_project/themes/app_theme.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:forms_project/view/client_list_event.dart';
import 'package:forms_project/view/data_client_invoice_screen.dart';
import 'package:forms_project/view/login_screen.dart';
import 'package:forms_project/widgets/custom_switch_option_widget.dart';
import 'package:forms_project/widgets/custom_top_left_buttom.dart';
import 'package:forms_project/widgets/dni_input_widget.dart';

class ClientDniScreen extends StatefulWidget {
  final String? nameEvent;
  final int? eventId;
  final int? numberEvents;

  const ClientDniScreen({super.key, this.nameEvent, this.eventId, this.numberEvents});

  @override
  State<ClientDniScreen> createState() => _ClientDniScreenState();
}

class _ClientDniScreenState extends State<ClientDniScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late NavigationService navigationService;
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  final _dniController = TextEditingController();
  bool _documentTypeIsCedula = true;
  bool _existClient = false;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);
    _eventController.text = widget.nameEvent!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
    _dniController.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _dniController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _eventController.dispose();
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _eventController.text,
                                style: TextStyle(color: Colors.white, fontSize: size.width * 0.02, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        searchDni(),
                      ],
                    ),
                  ),
                  CustomTopLeftButton(
                      icon: widget.numberEvents == 1 ? FontAwesomeIcons.arrowRightFromBracket : Icons.arrow_back_ios_new,
                      text: widget.numberEvents == 1 ? '' : 'Lista de eventos',
                      onPressed: () {
                        clearInputs();
                        if (widget.numberEvents == 1) {
                          _secureStorageHelper.storeValue('access_token', '0');
                          _secureStorageHelper.storeValue('role', '0');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientListEvent()));
                        }
                      })
                ],
              );
            },
          ),
        ));
  }

  Widget searchDni() {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: size.width * 0.25,
              child: DNIField(
                controller: _dniController,
                labelText: _documentTypeIsCedula ? 'Cédula' : 'Pasaporte',
                hintText: 'Ingrese ${_documentTypeIsCedula ? 'Cédula' : 'Pasaporte'}',
                mainColor: Colors.white,
                isCedula: _documentTypeIsCedula,
                onChanged: (value) async {
                  if (value.length == 10 && _documentTypeIsCedula == true) {
                    setState(() {
                      _existClient = true;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataClientInvoiceClientScreen(
                                  nameEvent: widget.nameEvent,
                                  eventId: widget.eventId,
                                  dni: _dniController.text,
                                  existClient: _existClient,
                                  numberEvents: widget.numberEvents,
                                  documentTypeIsCedula: _documentTypeIsCedula,
                                )));
                  } else if (value.length >= 6 && _documentTypeIsCedula == false) {
                    setState(() {
                      _existClient = true;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataClientInvoiceClientScreen(
                                  nameEvent: widget.nameEvent,
                                  eventId: widget.eventId,
                                  dni: _dniController.text,
                                  existClient: _existClient,
                                  numberEvents: widget.numberEvents,
                                  documentTypeIsCedula: _documentTypeIsCedula,
                                )));
                  }
                },
              ),
            ),
            SizedBox(height: size.height * 0.015),
            ElegantCustomStringSwitch(
              labelText: '',
              option1: 'Cédula',
              option2: 'Pasaporte',
              defaultOption: 'Cédula',
              onChanged: (value) {
                setState(() {
                  _documentTypeIsCedula = value == 'Cédula' ? true : false;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
