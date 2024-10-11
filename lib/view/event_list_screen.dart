import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forms_project/models/event/event_info_model.dart';
import 'package:flutter/services.dart';
import 'package:forms_project/routes/navigation_service.dart';
import 'package:forms_project/themes/app_theme.dart';
import 'package:forms_project/view/event_screen.dart';
import 'package:forms_project/viewmodel/event/ievent_viewmodel.dart';
import 'package:forms_project/widgets/custom_input_text_fiel_widget.dart';
import 'package:forms_project/widgets/custom_top_left_buttom.dart';
import 'package:forms_project/widgets/glass_pop_up_display_info.dart';
import 'package:forms_project/widgets/glass_popup_approved.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_single_selection_drop_box_widget.dart';
import '../widgets/data_range_picker_widget.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late NavigationService navigationService;
  final _dateStartController = TextEditingController();
  final _dateEndController = TextEditingController();
  final _dateRangeController = TextEditingController();
  final _nameEventController = TextEditingController();
  final _statusEventController = TextEditingController();

  late Future<void> Function() _loadEvents;

  final GlobalKey<CustomSingleSelectionDropBoxState> _singleSelectionDropBoxKey = GlobalKey<CustomSingleSelectionDropBoxState>();
  List<EventInfoModel?> _events = [];
  final statusMap = {
    'VIGENTE': 'VIGENTE',
    'SUSPENDIDO': 'SUSPENDIDO',
    'FINALIZADO': 'FINALIZADO',
  };

  bool datesValid = false;
  String? _dateErrorTextStart;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);
    _loadEvents = () async {
      final eventViewModel = context.read<IEventViewModel>();
      await eventViewModel.loadSearchedEvents('', '', '', '');
      setState(() {
        _events = eventViewModel.eventsSearched;
      });
    };
    _loadEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
    //_loadEvents();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void clearInputs() {
    _dateRangeController.clear();
    _dateStartController.clear();
    _dateEndController.clear();
    _nameEventController.clear();
    _statusEventController.clear();
    _singleSelectionDropBoxKey.currentState?.clearCustomSingleSelectionDropBoxStateInputs();
  }

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String year = dateTime.year.toString();
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = context.watch<IEventViewModel>();
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
                  child: Padding(
                    padding: EdgeInsets.all(size.height * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Listado de eventos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.025,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
                                Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.675,
                                      height: size.height * 0.082,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(color: Colors.transparent, width: size.width * 0.0007),
                                        borderRadius: BorderRadius.circular(size.width * 0.008 * 2.5),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: size.height * 0.025,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ElegantTextField(
                                                controller: _nameEventController,
                                                labelText: 'Nombre',
                                                hintText: 'Ingrese su nombre',
                                                mainColor: Colors.white,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(20),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.height * 0.015,
                                            ),
                                            SizedBox(
                                              height: size.height * 0.08,
                                              width: size.height * 0.002,
                                              child: const DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.height * 0.015,
                                            ),
                                            Expanded(
                                                child: ElegantDateRangePickerFormField(
                                              startController: _dateStartController,
                                              endController: _dateEndController,
                                              showRange: _dateRangeController,
                                              labelText: 'Rango de fechas',
                                              hintText: 'Seleccione el rango de fechas',
                                              errorText: _dateErrorTextStart,
                                            )),
                                            SizedBox(
                                              width: size.height * 0.015,
                                            ),
                                            SizedBox(
                                              height: size.height * 0.08,
                                              width: size.height * 0.002,
                                              child: const DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.height * 0.015,
                                            ),
                                            Expanded(
                                              child: CustomSingleSelectionDropBox(
                                                key: _singleSelectionDropBoxKey,
                                                hintText: 'Seleccione el estado del evento',
                                                labelText: 'Estado',
                                                items: const ['VIGENTE', 'SUSPENDIDO', 'FINALIZADO'],
                                                onChanged: (selectedItem) {
                                                  setState(() {
                                                    _statusEventController.text = statusMap[selectedItem]!;
                                                  });
                                                },
                                                displayValue: (item) => item,
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.height * 0.015,
                                            ),
                                            IconButton(
                                              focusColor: Colors.transparent,
                                              focusNode: FocusNode(canRequestFocus: false),
                                              onPressed: () async {
                                                _events = [];
                                                await eventViewModel.loadSearchedEvents(
                                                    _nameEventController.text,
                                                    _dateStartController.text,
                                                    _dateEndController.text,
                                                    _statusEventController.text);
                                                setState(() {
                                                  _events = eventViewModel.eventsSearched;
                                                  if (_events.isEmpty) {
                                                    _showPopupSearches(context, FontAwesomeIcons.magnifyingGlass,
                                                        'No se encontraron resultados para tu búsqueda');
                                                  }
                                                });
                                                clearInputs();
                                              },
                                              icon: Icon(
                                                Icons.search,
                                                size: size.height * 0.055,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: size.height * 0.6,
                            width: size.width,
                            padding: EdgeInsets.only(top: size.height * 0.03),
                            child: SingleChildScrollView(
                              child: PaginatedDataTable(
                                dataRowMinHeight: size.height * 0.1,
                                dataRowMaxHeight: size.height * 0.1,
                                columns: const [
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Evento',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Estado',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Monto mínimo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Monto máximo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Dinners triple cupón',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Cat. Comercio\n(No partcipa)',
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Entregable',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Fecha de inicio',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Fecha de fin',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Expanded(
                                      child: Text(
                                        'Editar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                source: EventDataTableSource(_events, context, _loadEvents),
                                rowsPerPage: 5,
                                columnSpacing: size.width * 0.01,
                                horizontalMargin: size.width * 0.015,
                                onPageChanged: (page) {},
                                showFirstLastButtons: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomTopLeftButton(
                    icon: Icons.arrow_back_ios_new,
                    onPressed: () {
                      clearInputs();
                      navigationService.navigateToEventModules(context);
                    },
                    text: 'Portal administrador'),
                legend(context)
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget legend(context) {
  final size = MediaQuery.of(context).size;
  return Positioned(
    left: size.width * 0.04,
    bottom: size.height * 0.075,
    child: Row(
      children: [
        const Text(
          'Vigente',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        Container(
          height: size.height * 0.02,
          width: size.height * 0.02,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        SizedBox(
          height: size.height * 0.035,
          width: size.height * 0.001,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        const Text(
          'Suspendido',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        Container(
          height: size.height * 0.02,
          width: size.height * 0.02,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        SizedBox(
          height: size.height * 0.035,
          width: size.height * 0.001,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        const Text(
          'Finalizado',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        Container(
          height: size.height * 0.02,
          width: size.height * 0.02,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        SizedBox(
          height: size.height * 0.035,
          width: size.height * 0.001,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        const Text(
          'Cupón',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        SvgPicture.asset(
          'assets/icons/ticket.svg',
          height: size.height * 0.04,
          width: size.width * 0.04,
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        SizedBox(
          height: size.height * 0.035,
          width: size.height * 0.001,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        const Text(
          'Kit',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        SvgPicture.asset(
          'assets/icons/gift.svg',
          height: size.height * 0.032,
          width: size.width * 0.032,
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
        SizedBox(
          width: size.height * 0.015,
        ),
      ],
    ),
  );
}

void _showPopup(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GlassPopupDisplayInfo(
        title: 'Categorías no participantes',
        message: message,
      );
    },
  );
}

void _showPopupSearches(BuildContext context, IconData icon, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GlassPopup(
        icon: icon,
        message: message,
      );
    },
  );
}

class EventDataTableSource extends DataTableSource {
  final List<EventInfoModel?> events;
  final BuildContext context;
  final Future<void> Function() _loadEvents;
  final Map<String, Color> statusColors = {
    'VIGENTE': Colors.green,
    'SUSPENDIDO': Colors.blue,
    'FINALIZADO': Colors.grey,
  };

  final Map<String, String> deliveryIcons = {
    'TICKET': 'assets/icons/ticket.svg',
    'KIT': 'assets/icons/gift.svg',
  };

  EventDataTableSource(this.events, this.context, this._loadEvents);

  @override
  DataRow? getRow(int index) {
    if (index >= events.length) return null;
    final data = events[index];
    return DataRow(cells: [
      DataCell(SingleChildScrollView(
        child: Text(
          data?.name ?? 'N/A',
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      )),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.025,
              width: MediaQuery.of(context).size.height * 0.025,
              decoration: BoxDecoration(
                color: statusColors[data?.status.toUpperCase()],
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
      ),
      DataCell(Center(
        child: Text(
          '\$ ${data?.minAmount.toStringAsFixed(2) ?? 'N/A'}',
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      )),
      DataCell(Center(
        child: Text(
          '\$ ${data?.maxAmount.toStringAsFixed(2) ?? 'N/A'}',
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      )),
      DataCell(Center(
        child: Text(
          (data?.paymentTypeVip.first.vip ?? false) ? 'Aplica' : 'No aplica',
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      )),
      DataCell(
        Center(
          child: (data?.commerceCategories?.isNotEmpty ?? false)
              ? SizedBox(
                  //width: MediaQuery.of(context).size.width * 0.085,
                  child: InkWell(
                    onTap: () {
                      String message =
                          (data?.commerceCategories?.map((e) => '• ${e.name}').join('\n') ?? 'No categories available');
                      _showPopup(context, message);
                    },
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ver categorías',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              //fontSize: MediaQuery.of(context).size.height * 0.016
                            )
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                )
              : Text(
                  'Todas las categorías\nparticipan',
                  style: TextStyle(
                    color: Colors.white, 
                    fontFamily: 'Poppins', 
                    fontSize: MediaQuery.of(context).size.height * 0.016),
                ),
        ),
      ),
      DataCell(Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              deliveryIcons[data?.deliveryType]!,
              height: MediaQuery.of(context).size.height * 0.054,
              width: MediaQuery.of(context).size.height * 0.054,
            )
          ],
        ),
      )),
      DataCell(Center(
        child: Text(
          formatDate(data?.startDate ?? 'N/A'),
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      )),
      DataCell(Center(
        child: Text(
          formatDate(data?.endDate ?? 'N/A'),
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      )),
      DataCell(Center(
        child: IconButton(
          icon: const Icon(
            FontAwesomeIcons.penToSquare,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventRegisterScreen(
                  idEvent: data?.id,
                ),
              ),
            ).then((_){
              _loadEvents();
            });
          },
        ),
      )),
    ]);
  }

  String formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String year = dateTime.year.toString();
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => events.length;

  @override
  int get selectedRowCount => 0;
}
