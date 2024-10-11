import 'package:forms_project/view/client_dni.dart';
import 'package:forms_project/view/client_list_event.dart';
import 'package:forms_project/view/data_client_invoice_screen.dart';
import 'package:forms_project/view/event_list_screen.dart';
import 'package:forms_project/view/event_modules.dart';
import 'package:forms_project/view/event_register_user.dart';
import 'package:forms_project/view/event_screen.dart';
import 'package:forms_project/view/login_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen(),),
      GoRoute(path: '/event', builder: (context, state) => const EventModulesScreen(),),
      GoRoute(path: '/event/register_event', builder: (context, state) => const EventRegisterScreen()),
      GoRoute(path: '/event/list_event', builder: (context, state) => const EventListScreen()),
      GoRoute(path: '/event/register_user', builder: (context, state) => const EventRegisterUser()),
      GoRoute(path: '/client/client_list_event', builder: (context, state) => const ClientListEvent()),
      GoRoute(path: '/client/client_dni', builder: (context, state) => const ClientDniScreen()),
      GoRoute(path: '/data_client_invoice', builder: (context, state) => const DataClientInvoiceClientScreen()),
    ],
  );
}
