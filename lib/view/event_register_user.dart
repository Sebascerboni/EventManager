import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forms_project/models/login/create_user_model.dart';
import 'package:forms_project/routes/navigation_service.dart';
import 'package:forms_project/services/login/login_service.dart';
import 'package:forms_project/themes/app_theme.dart';
import 'package:forms_project/viewmodel/login/ilogin_viewmodel.dart';
import 'package:forms_project/widgets/custom_input_text_fiel_widget.dart';
import 'package:forms_project/widgets/custom_submit_button_widget.dart';
import 'package:forms_project/widgets/custom_switch_option_widget.dart';
import 'package:forms_project/widgets/custom_text_widget.dart';
import 'package:forms_project/widgets/custom_top_left_buttom.dart';
import 'package:forms_project/widgets/glass_popup_approved.dart';
import 'package:provider/provider.dart';

class EventRegisterUser extends StatefulWidget {
  const EventRegisterUser({super.key});

  @override
  State<EventRegisterUser> createState() => _EventRegisterUserState();
}

class _EventRegisterUserState extends State<EventRegisterUser> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late NavigationService navigationService;

  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifyPasswordController = TextEditingController();

  bool _existUser = false;
  bool validateRegisterUserForm = false;
  String _state = 'Activo';

  final FocusNode _focusNodeInputUser = FocusNode();
  final FocusNode _focusNodeInputPassword = FocusNode();
  final FocusNode _focusNodeInputVerifyPassword = FocusNode();

  late Future<List<CreateUserModel>> _futureUsers;

  String? _errorPasswordMessage;
  String? _errorValidatePasswordMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    _futureUsers = _fetchUsers();
    _verifyPasswordController.addListener(_validateForm);
  }

  Future<List<CreateUserModel>> _fetchUsers() async {
    final loginService = LoginService();
    return await loginService.fetchUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _clearInputs() {
    _userController.clear();
    _emailController.clear();
    _passwordController.clear();
    _verifyPasswordController.clear();

    setState(() {
      validateRegisterUserForm = false;
      _errorPasswordMessage = null;
      _errorValidatePasswordMessage = null;
      _existUser = false;
    });
  }

  void _validateForm() {
    setState(() {
      List<String> errorMessages = [];
      if (_passwordController.text.length < 8) {
        errorMessages.add('Mínimo 8 caracteres');
      }

      if (!_passwordController.text.contains(RegExp(r'[a-z]'))) {
        errorMessages.add('Una letra minúscula');
      }

      if (!_passwordController.text.contains(RegExp(r'[A-ZÑ]'))) {
        errorMessages.add('Una letra mayúscula');
      }

      if (!_passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        errorMessages.add('Un carácter especial');
      }

      if (errorMessages.isNotEmpty) {
        _errorPasswordMessage = errorMessages.join('\n');
      } else if (_passwordController.text != _verifyPasswordController.text && _verifyPasswordController.text.isNotEmpty) {
        _errorPasswordMessage = 'Las contraseñas no coinciden';
        _errorValidatePasswordMessage = 'Las contraseñas no coinciden';
      } else {
        _errorPasswordMessage = null;
        _errorValidatePasswordMessage = null;
      }
    });
  }

  bool _validateSubmitInput() {
    validateRegisterUserForm = _userController.text.isNotEmpty && _errorPasswordMessage == null;
    return validateRegisterUserForm;
  }

  void _updateUserListTable() async {
    final updatedUsers = await _fetchUsers();
    setState(() {
      _futureUsers = Future.value(updatedUsers);
    });
  }

  void _showPopup(BuildContext context, bool isSuccess, String message) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassPopup(
          icon: isSuccess ? Icons.check_circle : Icons.warning,
          message: message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Scaffold(
          body: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return Stack(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      height: size.height,
                      width: size.width,
                      decoration: BoxDecoration(gradient: AppTheme().animatedRadialGradient(_animationController)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 1, child: registerUser()),
                          SizedBox(width: size.width * 0.08),
                          Expanded(flex: 2, child: listUser()),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Administrador de usuarios',
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
                      icon: Icons.arrow_back_ios_new,
                      onPressed: () {
                        _clearInputs();
                        navigationService.navigateToEventModules(context);
                      },
                      text: 'Portal administrador'),
                ],
              );
            },
          ),
        ));
  }

  Widget registerUser() {
    final size = MediaQuery.of(context).size;

    final loginViewModel = context.watch<ILoginViewModel>();
    return Center(
      child: Container(
        height: size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(size.width * 0.008 * 2.5),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.06,
            bottom: size.height * 0.06,
            left: size.width * 0.05,
          ),
          child: SingleChildScrollView(
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElegantTextField(
                    controller: _userController,
                    focusNode: _focusNodeInputUser,
                    readOnly: _existUser,
                    onFieldSubmitted: (_) => _focusNodeInputPassword.requestFocus(),
                    labelText: 'Alias',
                    hintText: 'Ingresar alias',
                    mainColor: Colors.white,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ_-]')),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  ElegantTextField(
                    controller: _passwordController,
                    focusNode: _focusNodeInputPassword,
                    onFieldSubmitted: (_) => _focusNodeInputVerifyPassword.requestFocus(),
                    labelText: 'Contraseña',
                    hintText: 'Ingresar contraseña',
                    mainColor: Colors.white,
                    obscureText: true,
                    errorText: _errorPasswordMessage,
                    validator: (value) {
                      _validateForm();
                      return null;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(
                        RegExp(r'\s'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  ElegantTextField(
                    controller: _verifyPasswordController,
                    focusNode: _focusNodeInputVerifyPassword,
                    labelText: 'Confirmar contraseña',
                    hintText: 'Ingresar contraseña',
                    mainColor: Colors.white,
                    errorText: _errorValidatePasswordMessage,
                    obscureText: true,
                    validator: (value) {
                      _validateForm();
                      return null;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(
                        RegExp(r'\s'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  _existUser
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                                flex: size.width < 450 ? 1 : 1,
                                child: const CustomTextWidget(
                                  text: 'Estado',
                                )),
                            ElegantCustomStringSwitch(
                                option1: 'Activo',
                                option2: 'Inactivo',
                                defaultOption: _state,
                                onChanged: (value) {
                                  setState(() {
                                    _state = value;
                                  });
                                }),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: loginViewModel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SubmitButton(
                                validateEventForm: _validateSubmitInput(),
                                controllers: [
                                  _userController,
                                ],
                                onPressed: () async {
                                  final userModel = CreateUserModel(
                                      username: _userController.text,
                                      password: _passwordController.text,
                                      state: _state,
                                      role: 'User');
                                  try {
                                    _existUser == false ? await loginViewModel.createUser(userModel) : await loginViewModel.updateUser(userModel);
                                    if (!mounted) return;
                                    _showPopup(context, true, _existUser == false ? 'Registro de usuario exitoso' : 'Actualización de usuario exitoso');

                                    _updateUserListTable();
                                  } catch (e) {
                                    _showPopup(context, false, e.toString());
                                  } finally {
                                    _clearInputs();
                                  }
                                },
                                buttonText: _existUser == false ? 'Registrar usuario' : 'Actualizar usuario',
                              ),
                      ),
                      SizedBox(width: size.height * 0.015),
                      Expanded(
                        child: InkWell(
                          onTap: _clearInputs,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: size.height * 0.022,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listUser() {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(size.width * 0.008 * 2.5),
        ),
        child: SingleChildScrollView(
          child: FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: FutureBuilder<List<CreateUserModel>>(
              future: _futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No users found');
                } else {
                  final users = snapshot.data!
                    ..sort((a, b) {
                      final aDate = a.lastUpdate;
                      final bDate = b.lastUpdate;

                      if (aDate == null && bDate == null) return 0;
                      if (aDate == null) return 1;
                      if (bDate == null) return -1;
                      return bDate.compareTo(aDate);
                    });

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      // dataRowHeight: size.height * 0.08,
                      dataRowMinHeight: size.height * 0.08,
                      dataRowMaxHeight: size.height * 0.08,
                      columns: [
                        DataColumn(label: Text('Nombre', style: TextStyle(fontFamily: 'Poppins-Bold', fontSize: size.height * 0.023))),
                        DataColumn(label: Text('Fecha edición', style: TextStyle(fontFamily: 'Poppins-Bold', fontSize: size.height * 0.023))),
                        DataColumn(label: Text('Rol', style: TextStyle(fontFamily: 'Poppins-Bold', fontSize: size.height * 0.023))),
                        DataColumn(label: Text('Estado', style: TextStyle(fontFamily: 'Poppins-Bold', fontSize: size.height * 0.023))),
                        DataColumn(label: Text('Editar', style: TextStyle(fontFamily: 'Poppins-Bold', fontSize: size.height * 0.023))),
                      ],
                      rows: users.map((user) {
                        return DataRow(cells: [
                          DataCell(Text(user.username, style: TextStyle(fontFamily: 'Poppins-Thin', fontSize: size.height * 0.021))),
                          DataCell(Text(user.lastUpdate.toString().split(' ')[0], style: TextStyle(fontFamily: 'Poppins-Thin', fontSize: size.height * 0.021))),
                          DataCell(Text(user.role == 'Admin' ? 'Administrador' : 'Usuario', style: TextStyle(fontFamily: 'Poppins-Thin', fontSize: size.height * 0.021))),
                          DataCell(Text(user.state, style: TextStyle(fontFamily: 'Poppins-Thin', fontSize: size.height * 0.021))),
                          DataCell(
                            user.role == 'User'
                                ? Center(
                                    child: IconButton(
                                      icon: const Icon(FontAwesomeIcons.penToSquare),
                                      onPressed: () {
                                        _existUser = true;
                                        _userController.text = user.username;
                                        _emailController.text = user.email ?? '';
                                        _state = user.state;
                                        _errorPasswordMessage = null;
                                        _errorValidatePasswordMessage = null;
                                      },
                                    ),
                                  )
                                : Container(),
                          ),
                        ]);
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
