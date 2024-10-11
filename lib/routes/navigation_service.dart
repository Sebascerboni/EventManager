import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  final BuildContext context;
  bool? isLogin;

  NavigationService(this.context);


  void navigateToLogin(BuildContext context) {
    context.go('/');
  }

  void navigateToEventModules(BuildContext context) {
    context.go('/event');
  }

  void navigateToEventRegister(BuildContext context) {
    context.go('/event/register_event');
  }

  void navigateToEventList(BuildContext context) {
    context.go('/event/list_event');
  }

  void navigateToEventRegisterUser(BuildContext context) {
    context.go('/event/register_user');
  }

  void navigateToClientDni(BuildContext context) {
    context.go('/client/client_dni');
  }

  void navigateToClientListEvent(BuildContext context) {
    context.go('/client/client_list_event');
  }

  void navigateToDataClientAndInvoice(BuildContext context) {
    context.go('/data_client_invoice');
  }
}
