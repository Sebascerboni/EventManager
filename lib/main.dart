import 'package:flutter/material.dart';
import 'package:forms_project/routes/app_router.dart';
import 'package:forms_project/routes/navigation_service.dart';
import 'package:forms_project/services/client/client_service.dart';
import 'package:forms_project/services/commerce/commerce_service.dart';
import 'package:forms_project/services/conditionsAndPolicies/conditions_policies_service.dart';
import 'package:forms_project/services/event/event_service.dart';
import 'package:forms_project/services/invoice/invoice_service.dart';
import 'package:forms_project/services/login/login_service.dart';
import 'package:forms_project/services/payment/payment_type_service.dart';
import 'package:forms_project/services/points/points_service.dart';
import 'package:forms_project/themes/app_theme.dart';
import 'package:forms_project/viewmodel/client/client_viewmodel.dart';
import 'package:forms_project/viewmodel/client/iclient_viewmodel.dart';
import 'package:forms_project/viewmodel/commerce/commerce_viewmodel.dart';
import 'package:forms_project/viewmodel/commerce/icommerce_viewmodel.dart';
import 'package:forms_project/viewmodel/conditionsAndPolicies/conditions_policies_viewmodel.dart';
import 'package:forms_project/viewmodel/conditionsAndPolicies/iconditions_policies_viewmodel.dart';
import 'package:forms_project/viewmodel/event/event_viewmodel.dart';
import 'package:forms_project/viewmodel/event/ievent_viewmodel.dart';
import 'package:forms_project/viewmodel/invoice/iinvoice_viewmodel.dart';
import 'package:forms_project/viewmodel/invoice/invoice_viewmodel.dart';
import 'package:forms_project/viewmodel/login/login_viewmodel.dart';
import 'package:forms_project/viewmodel/payment/ipayment_viewmodel.dart';
import 'package:forms_project/viewmodel/payment/payment_viewmodel.dart';
import 'package:forms_project/viewmodel/points/ipoints_viewmodel.dart';
import 'package:forms_project/viewmodel/points/points_viewmodel.dart';
import 'package:provider/provider.dart';
import 'viewmodel/login/ilogin_viewmodel.dart';

void main() {
  // configureApiRestService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<IEventViewModel>(create: (context) => EventViewModel(EventService())),
        ChangeNotifierProvider<ILoginViewModel>(create: (context) => LoginViewModel(LoginService(), NavigationService(context))),
        ChangeNotifierProvider<IClientViewModel>(create: (_) => ClientViewModel(ClientService())),
        ChangeNotifierProvider<ICommerceViewModel>(create: (_) => CommerceViewModel(CommerceService())),
        ChangeNotifierProvider<IInvoiceViewModel>(create: (_) => InvoiceViewModel(InvoiceService())),
        ChangeNotifierProvider<IPaymentTypeViewModel>(create: (_) => PaymentTypeViewModel(PaymentTypeService())),
        ChangeNotifierProvider<IPointsViewModel>(create: (_) => PointsViewModel(PointsService())),
        ChangeNotifierProvider<IConditionsPoliciesViewModel>(create: (_) => ConditionsPoliciesViewModel(ConditionsPoliciesService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).theme(),
      routerConfig: AppRouter().router,
    );
  }
}