import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forms_project/routes/navigation_service.dart';
import 'package:forms_project/themes/app_theme.dart';
import 'package:forms_project/utils/secure_storage.dart';
import 'package:forms_project/view/client_dni.dart';
import 'package:forms_project/viewmodel/commerce/icommerce_viewmodel.dart';
import 'package:forms_project/viewmodel/event/ievent_viewmodel.dart';
import 'package:forms_project/widgets/custom_single_selection_drop_box_widget.dart';
import 'package:forms_project/widgets/custom_top_left_buttom.dart';
import 'package:provider/provider.dart';

class ClientListEvent extends StatefulWidget {
  const ClientListEvent({super.key});

  @override
  State<ClientListEvent> createState() => _ClientListEventState();
}

class _ClientListEventState extends State<ClientListEvent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late NavigationService navigationService;
  late String _nameSelectedEvent;
  late int _eventID;
  late IEventViewModel eventViewModel;
  late int _numberEvents;
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  final _eventController = TextEditingController();

  void _loadCommerces(int? eventId) {
    context.read<ICommerceViewModel>().loadCommerces(eventId!);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    _loadActiveEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
    _loadActiveEvents();
  }

  @override
  void dispose() {
    _controller.dispose();
    _eventController.dispose();
    super.dispose();
  }

  void _loadEventInfo(int eventId) async {
    await eventViewModel.loadEventInfo(eventId);
  }

  Future<void> _loadActiveEvents() async {
    eventViewModel = context.read<IEventViewModel>();
    await eventViewModel.getActiveEvents();
    _numberEvents = eventViewModel.getActiveEventsObjects().length;
  }

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
                      children: [selectEvent()],
                    ),
                  ),
                  CustomTopLeftButton(
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      onPressed: () {
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

  Widget selectEvent() {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.3,
          child: Consumer<IEventViewModel>(builder: (context, eventViewModel, child) {
            return FutureBuilder<void>(
              future: eventViewModel.reloadActiveEvents(),
              builder: (context, snapshot) {
                return CustomSingleSelectionDropBox(
                  items: eventViewModel.getActiveEventsObjects(),
                  onChanged: (selectedItem) {
                    setState(() {
                      _numberEvents = eventViewModel.getActiveEventsObjects().length;
                      _loadCommerces(selectedItem!.id);
                      _nameSelectedEvent = selectedItem.name;
                      _eventID = selectedItem.id;
                      _loadEventInfo(_eventID);
                    });
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ClientDniScreen(nameEvent: _nameSelectedEvent, eventId: _eventID, numberEvents: _numberEvents)));
                  },
                  labelText: 'Seleccione el evento',
                  hintText: 'Seleccione el evento',
                  displayValue: (item) => item.name,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
