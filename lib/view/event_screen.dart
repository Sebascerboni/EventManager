import 'package:flutter/material.dart';
import 'package:forms_project/models/event/event_model.dart';
import 'package:forms_project/models/payment/payment_vip_model.dart';
import 'package:forms_project/routes/navigation_service.dart';
import 'package:forms_project/themes/app_theme.dart';
import 'package:forms_project/utils/regex_utils.dart';
import 'package:forms_project/viewmodel/event/ievent_viewmodel.dart';
import 'package:forms_project/widgets/custom_bool_switch.dart';
import 'package:forms_project/widgets/custom_multi_selection_drop_box_widget.dart';
import 'package:forms_project/widgets/custom_date_picker_form_field_widget.dart';
import 'package:forms_project/widgets/custom_input_text_fiel_widget.dart';
import 'package:forms_project/widgets/custom_single_selection_drop_box_widget.dart';
import 'package:forms_project/widgets/custom_switch_option_widget.dart';
import 'package:forms_project/widgets/custom_text_widget.dart';
import 'package:forms_project/widgets/custom_top_left_buttom.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_input_number_field_widget.dart';
import '../widgets/custom_submit_button_widget.dart';
import 'package:flutter/services.dart';

import '../widgets/glass_popup_approved.dart';

class EventRegisterScreen extends StatefulWidget {
  final int? idEvent;

  const EventRegisterScreen({super.key, this.idEvent});

  @override
  State<EventRegisterScreen> createState() => _EventRegisterScreenState();
}

class _EventRegisterScreenState extends State<EventRegisterScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<CustomMultiSelectionDropBoxState> _multiSelectionDropBoxKey = GlobalKey<CustomMultiSelectionDropBoxState>();
  final GlobalKey<CustomSingleSelectionDropBoxState> _singleSelectionDropBoxKey = GlobalKey<CustomSingleSelectionDropBoxState>();
  late NavigationService navigationService;
  late String _statusEventController = 'VIGENTE';
  final bool _vipPaymentController = false;
  final _dateStartController = TextEditingController();
  final _dateEndController = TextEditingController();
  final _nameEventController = TextEditingController();
  final _minAmountEventController = TextEditingController();
  final _maxAmountEventController = TextEditingController();
  late List<String> _selectedCategoriesController = [];
  final _selectedDeliverableController = TextEditingController();
  late final List<String> _selectedVipPaymentType = [];
  late AnimationController _controller;
  late bool _isSelectedDinners = false;
  bool _existEvent = false;
  late int _idEvent;
  late IEventViewModel eventViewModel;

  final FocusNode _focusNodeInputNameEvent = FocusNode();
  final FocusNode _focusNodeInputDateStart = FocusNode();
  final FocusNode _focusNodeInputDateEnd = FocusNode();
  final FocusNode _focusNodeInputMinAmountEvent = FocusNode();
  final FocusNode _focusNodeInputMaxAmountEvent = FocusNode();
  final FocusNode _focusNodeInputCategories = FocusNode();
  final FocusNode _focusNodeInputDeliverable = FocusNode();

  bool validateEventForm = false;
  String? _dateErrorTextStart;
  String? _dateErrorTextEnd;
  String? _amountErrorText;
  String? _minAmountErrorText;
  bool dataRangeValid = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);
    eventViewModel = context.read<IEventViewModel>();
    eventViewModel.getCategories();

    navigationService = NavigationService(context);
    _initializeEvent();

    _nameEventController.addListener(_validateForm);
    _dateStartController.addListener(_validateForm);
    _dateEndController.addListener(_validateForm);
    _minAmountEventController.addListener(_validateForm);
    _maxAmountEventController.addListener(_validateForm);
    _selectedDeliverableController.addListener(_validateForm);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
  }

  bool datesValid = false;

  Future<void> _initializeEvent() async {
    _idEvent = widget.idEvent ?? 0;
    await eventViewModel.loadEventInfo(_idEvent);

    if (eventViewModel.eventInfo != null) {
      setState(() {
        _existEvent = true;
        _idEvent = eventViewModel.eventInfo!.id;
        _nameEventController.text = eventViewModel.eventInfo!.name;
        _dateStartController.text = eventViewModel.eventInfo!.startDate.split('T')[0];
        _dateEndController.text = eventViewModel.eventInfo!.endDate.split('T')[0];
        _statusEventController = eventViewModel.eventInfo!.status;

        _selectedCategoriesController = eventViewModel.eventInfo!.commerceCategories!
            .map((category) => category.name.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' '))
            .toList();
        _multiSelectionDropBoxKey.currentState?.setSelectedItems(
          _selectedCategoriesController
        );

        _minAmountEventController.text = eventViewModel.eventInfo!.minAmount.toString();
        _maxAmountEventController.text = eventViewModel.eventInfo!.maxAmount.toString();

        _selectedDeliverableController.text = eventViewModel.eventInfo!.deliveryType.toString();
        _singleSelectionDropBoxKey.currentState?.setSelectedItem(
          eventViewModel.eventInfo!.deliveryType,
        );

        _isSelectedDinners = eventViewModel.eventInfo!.paymentTypeVip.first.vip;
      });
    } else {
      setState(() {
        _existEvent = false;
        clearInputs();
      });
    }
  }

  void _validateForm() {
    setState(() {
      final String startText = _dateStartController.text;
      final String endText = _dateEndController.text;
      if (startText.isNotEmpty && endText.isNotEmpty) {
        if (RegexUtils.isValidDate(startText) && RegexUtils.isValidDate(endText)) {
          final startDate = DateTime.parse(startText);
          final endDate = DateTime.parse(endText);
          if (startDate.isAfter(endDate)) {
            _dateErrorTextStart = 'Rango de fecha no válido';
            _dateErrorTextEnd = 'Rango de fecha no válido';
            datesValid = false;
          } else if (startDate.isAtSameMomentAs(endDate)) {
            _dateErrorTextStart = 'Las fechas no pueden ser iguales';
            _dateErrorTextEnd = 'Las fechas no pueden ser iguales';
            datesValid = false;
          } else {
            _dateErrorTextStart = null;
            _dateErrorTextEnd = null;
            datesValid = true;
          }
        } else {
          if (!RegexUtils.isValidDate(startText) && startText.length > 10) {
            _dateErrorTextStart = 'Ingrese la fecha en el formato correcto';
          } else {
            _dateErrorTextStart = null;
          }

          if (!RegexUtils.isValidDate(endText) && endText.length > 10) {
            _dateErrorTextEnd = 'Ingrese la fecha en el formato correcto';
          } else {
            _dateErrorTextEnd = null;
          }
          datesValid = false;
        }
      }

      bool amountsValid = (_minAmountEventController.text.isNotEmpty && _maxAmountEventController.text.isNotEmpty) &&
          double.parse(_minAmountEventController.text) < double.parse(_maxAmountEventController.text);

      if (_minAmountEventController.text.isNotEmpty && _maxAmountEventController.text.isNotEmpty) {
        if (double.parse(_minAmountEventController.text) >= double.parse(_maxAmountEventController.text)) {
          _amountErrorText = 'El monto mínimo no puede ser mayor al monto máximo';
        } else {
          _amountErrorText = null;
        }
      }

      if (_minAmountEventController.text.isNotEmpty && double.parse(_minAmountEventController.text) < 5) {
        _minAmountErrorText = "El monto debe ser mayor a \$5";
      } else {
        _minAmountErrorText = null;
      }

      validateEventForm = _nameEventController.text.isNotEmpty && _selectedDeliverableController.text.isNotEmpty && datesValid && amountsValid;
    });
  }

  void clearInputs() {
    _dateStartController.clear();
    _dateEndController.clear();
    _minAmountEventController.clear();
    _maxAmountEventController.clear();
    _selectedCategoriesController.clear();
    _selectedVipPaymentType.clear();

    _selectedDeliverableController.clear();
    _selectedCategoriesController.clear();

    _isSelectedDinners = false;
    datesValid = false;
    _isSelectedDinners = false;
    _statusEventController = 'SUSPENDIDO';

    _multiSelectionDropBoxKey.currentState?.clearCustomMultiSelectionDropBoxInputs();
    _singleSelectionDropBoxKey.currentState?.clearCustomSingleSelectionDropBoxStateInputs();

    _idEvent = 0;
    _nameEventController.clear();
    setState(() {
      _existEvent = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameEventController.dispose();
    _dateStartController.dispose();
    _dateEndController.dispose();
    _minAmountEventController.dispose();
    _maxAmountEventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final eventViewModel = context.watch<IEventViewModel>();

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
                  decoration: BoxDecoration(
                    gradient: AppTheme().animatedRadialGradient(_controller),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                      vertical: size.height * 0.125,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(size.width * 0.008 * 2.5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.05,
                              horizontal: size.height * 0.1,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(1),
                                    child: ElegantTextField(
                                      mainColor: Colors.white,
                                      controller: _nameEventController,
                                      focusNode: _focusNodeInputNameEvent,
                                      onFieldSubmitted: (_) => _focusNodeInputDateStart.requestFocus(),
                                      onChanged: (value) async {},
                                      labelText: 'Nombre del evento',
                                      hintText: 'Ingrese el nombre del evento',
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(26),
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s\d]'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(2),
                                    child: ElegantDatePickerFormField(
                                      controller: _dateStartController,
                                      initialDate: DateTime.now(),
                                      focusNode: _focusNodeInputDateStart,
                                      onFieldSubmited: (_) => _focusNodeInputDateEnd.requestFocus(),
                                      labelText: 'Fecha de inicio',
                                      hintText: 'Ingrese la fecha (yyyy-mm-dd)',
                                      onValidationChanged: (_) => _validateForm(),
                                      errorText: _dateErrorTextStart,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(3),
                                    child: ElegantDatePickerFormField(
                                      controller: _dateEndController,
                                      focusNode: _focusNodeInputDateEnd,
                                      initialDate: DateTime.tryParse(_dateStartController.text),
                                      onFieldSubmited: (_) => _focusNodeInputMinAmountEvent.requestFocus(),
                                      labelText: 'Fecha de fin',
                                      hintText: 'Ingrese la fecha (yyyy-mm-dd)',
                                      onValidationChanged: (_) => _validateForm(),
                                      errorText: _dateErrorTextEnd,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  _existEvent
                                      ? Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  flex: size.width < 450 ? 1 : 1,
                                                  child: const CustomTextWidget(
                                                    text: 'Estado del evento',
                                                  )),
                                              Flexible(
                                                flex: size.width < 450 ? 2 : 3,
                                                child: Center(
                                                  child: ElegantCustomStringSwitch(
                                                    option1: 'Activo',
                                                    option2: 'Inactivo',
                                                    defaultOption: _statusEventController == 'VIGENTE' ? 'Activo' : 'Inactivo',
                                                    onChanged: (selectedOption) {
                                                      setState(() {
                                                        selectedOption == 'Activo'
                                                            ? _statusEventController = 'VIGENTE'
                                                            : _statusEventController = 'SUSPENDIDO';
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(size.width * 0.008 * 2.5),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(4),
                                    child: CustomMultiSelectionDropBox<String>(
                                      key: _multiSelectionDropBoxKey,
                                      focusNode: _focusNodeInputCategories,
                                      hintText: 'Seleccione la(s) categoría(s) no participantes',
                                      labelText: 'Categorías no participantes',
                                      items: eventViewModel.categories.map((category) => category.name).toList(),
                                      onChanged: (selectedCategories) {
                                        setState(() {
                                          _selectedCategoriesController = selectedCategories;
                                        });
                                      },
                                      displayValue: (items) => items,

                                      initialSelectedItems:
                                      _selectedCategoriesController,
                                      //eventViewModel.categories.where((category) => _selectedCategoriesController.contains(category.name)).toList()

                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(5),
                                    child: ElegantNumberField(
                                      mainColor: Colors.white,
                                      controller: _minAmountEventController,
                                      focusNode: _focusNodeInputMinAmountEvent,
                                      onFieldSubmited: (_) => _focusNodeInputMaxAmountEvent.requestFocus(),
                                      labelText: 'Valor mínimo de participación',
                                      hintText: 'Ingrese monto mínimo para participar',
                                      errorText: _minAmountErrorText,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^(?!0)\d*\.?\d*$')),
                                        DecimalTextInputFormatter(decimalRange: 2),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(6),
                                    child: ElegantNumberField(
                                      mainColor: Colors.white,
                                      controller: _maxAmountEventController,
                                      focusNode: _focusNodeInputMaxAmountEvent,
                                      onFieldSubmited: (_) => _focusNodeInputNameEvent.requestFocus(),
                                      labelText: 'Valor máximo por factura',
                                      hintText: 'Ingrese monto máximo que participa',
                                      errorText: _amountErrorText,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^(?!0)\d*\.?\d*$')),
                                        DecimalTextInputFormatter(decimalRange: 2),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(7),
                                    child: CustomSingleSelectionDropBox(
                                      key: _singleSelectionDropBoxKey,
                                      hintText: 'Seleccione el entregable',
                                      labelText: 'Entregables',
                                      items: const ['KIT', 'TICKET'],
                                      focusNode: _focusNodeInputDeliverable,
                                      initialSelectedItem: _selectedDeliverableController.text,
                                      onFieldSubmited: (_) => _focusNodeInputNameEvent.requestFocus(),
                                      onChanged: (selectedItem) {
                                        setState(() {
                                          _selectedDeliverableController.text = selectedItem!;
                                          _validateForm();
                                        });
                                      },
                                      displayValue: (item) => item,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(flex: size.width < 450 ? 1 : 2, child: const CustomTextWidget(text: 'Dinners triple cupón')),
                                        Flexible(
                                          flex: size.width < 450 ? 2 : 5,
                                          child: ElegantCustomBoolSwitch(
                                            option1: 'Aplica',
                                            option2: 'No aplica',
                                            defaultValue: _isSelectedDinners,
                                            onChanged: (selectedOption) {
                                              setState(() {
                                                _isSelectedDinners = selectedOption;
                                                if (!_vipPaymentController) {
                                                  _selectedVipPaymentType.clear();
                                                }
                                                _validateForm();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  if (eventViewModel.isLoading) const Center(child: CircularProgressIndicator()) else SubmitButton(
                                          buttonText: _existEvent == false ? 'Registrar evento' : 'Actualizar evento',
                                          controllers: [
                                            _nameEventController,
                                            _dateStartController,
                                            _dateEndController,
                                            _minAmountEventController,
                                            _minAmountEventController
                                          ],
                                          validateEventForm: validateEventForm,
                                          onPressed: () async {
                                            try {
                                              final eventModel = EventModel(
                                                id: _idEvent,
                                                eventName: _nameEventController.text,
                                                startDate: DateTime.parse(_dateStartController.text),
                                                endDate: DateTime.parse(_dateEndController.text),
                                                status: _existEvent == false ? 'VIGENTE' : _statusEventController,
                                                deliveryType: _selectedDeliverableController.text,
                                                minAmount: double.parse(_minAmountEventController.text),
                                                maxAmount: double.parse(_maxAmountEventController.text),
                                                categoryNamesList: List.from(_selectedCategoriesController),
                                                paymentTypesVip: [
                                                  PaymentTypeVipModel(
                                                    id: _existEvent ? 3 : null,
                                                    paymentTypeName: 'DINNERS CLUB',
                                                    vip: _isSelectedDinners,
                                                    vipCouponAmount:
                                                        _isSelectedDinners == true && _selectedDeliverableController.text == 'TICKET' ? 3 : 1,
                                                  ),
                                                ],
                                              );

                                              if (_existEvent == false) {
                                                await eventViewModel.createEvent(eventModel);
                                              } else {
                                                await eventViewModel.updateEvent(eventModel);
                                              }

                                              _showPopup(context, true,
                                                  _existEvent == false ? 'Evento ingresado exitosamente' : 'Evento actualizado exitosamente');
                                            } catch (e) {
                                              _showPopup(context, false, e.toString());
                                            } finally {
                                              clearInputs();
                                              _nameEventController.clear();
                                            }
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                        _existEvent == false ? 'Creación de evento' : 'Actualización de evento',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                CustomTopLeftButton(
                    icon: Icons.arrow_back_ios_new,
                    onPressed: () {
                      if (!_existEvent) {
                        navigationService.navigateToEventModules(context);
                      } else {
                        Navigator.pop(context);
                        navigationService.navigateToEventList(context);
                      }
                      clearInputs();
                    },
                    text: _existEvent == true ? 'Lista de eventos' : 'Portal administrador'),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showPopup(BuildContext context, bool isSuccess, String message) async {
    final shouldNavigateToList = _existEvent;
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassPopup(
          icon: isSuccess ? Icons.check_circle : Icons.warning,
          message: message,
          onAccept: () {
            if (shouldNavigateToList) {
              Navigator.pop(context);
              navigationService.navigateToEventList(context);
            } else {
              navigationService.navigateToEventModules(context);
            }
          },
        );
      },
    );
  }
}
