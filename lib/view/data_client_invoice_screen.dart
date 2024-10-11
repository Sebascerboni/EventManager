import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forms_project/models/deliverable/deriverable_kit.dart';
import 'package:forms_project/models/points/points_model.dart';
import 'package:forms_project/view/client_dni.dart';
import 'package:forms_project/viewmodel/conditionsAndPolicies/iconditions_policies_viewmodel.dart';
import 'package:forms_project/viewmodel/points/ipoints_viewmodel.dart';
import 'package:forms_project/widgets/custom_checkbox.dart';
import 'package:forms_project/widgets/custom_search_widget.dart';
import 'package:forms_project/widgets/custom_top_left_buttom.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_project/models/client/client_action_request.dart';
import 'package:forms_project/models/invoice/invoice_conditios_model.dart';
import 'package:forms_project/models/invoice/invoice_model.dart';
import 'package:forms_project/models/invoice/invoice_payment_model.dart';
import 'package:forms_project/utils/regex_utils.dart';
import 'package:forms_project/viewmodel/client/iclient_viewmodel.dart';
import 'package:forms_project/viewmodel/commerce/icommerce_viewmodel.dart';
import 'package:forms_project/viewmodel/event/ievent_viewmodel.dart';
import 'package:forms_project/viewmodel/invoice/iinvoice_viewmodel.dart';
import 'package:forms_project/viewmodel/payment/ipayment_viewmodel.dart';
import 'package:forms_project/widgets/custom_date_picker_form_field_widget.dart';
import 'package:forms_project/widgets/custom_input_number_field_widget.dart';
import 'package:forms_project/widgets/custom_input_text_fiel_widget.dart';
import 'package:forms_project/widgets/custom_single_selection_drop_box_widget.dart';
import 'package:forms_project/widgets/dni_input_widget.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../models/deliverable/deliverable.dart';
import '../routes/navigation_service.dart';
import '../themes/app_theme.dart';
import '../widgets/custom_bool_switch.dart';
import '../widgets/custom_submit_button_widget.dart';
import '../widgets/glass_pop_up_display_info.dart';
import '../widgets/glass_popup_approved.dart';
import '../widgets/payment_method_widget.dart';

class DataClientInvoiceClientScreen extends StatefulWidget {
  final String? nameEvent;
  final int? eventId;
  final String? dni;
  final bool? existClient;
  final int? numberEvents;
  final bool? documentTypeIsCedula;

  const DataClientInvoiceClientScreen({super.key, this.nameEvent, this.eventId, this.dni, this.existClient, this.numberEvents, this.documentTypeIsCedula});

  @override
  State<DataClientInvoiceClientScreen> createState() => _DataClientInvoiceClientScreenState();
}

class _DataClientInvoiceClientScreenState extends State<DataClientInvoiceClientScreen> with SingleTickerProviderStateMixin {
  final _dniController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _eventName = TextEditingController();
  final _commerceController = TextEditingController();
  final _invoiceIDController = TextEditingController();

  final List<InvoicePaymentModel> _paymentMethodsSelected = [];
  final _totalAmountController = TextEditingController();
  final _invoiceIssueDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  late NavigationService navigationService;
  late AnimationController _animationController;
  bool _documentTypeIsCedula = true;
  late bool _isMale = true;
  bool _existClient = false;
  late bool _isEmailValid = true;
  late int _commerceId;
  late int _eventID;
  double _totalAmount = 0.0;
  double _totalPaid = 0.0;
  List<String> _availablePaymentMethods = [];
  List<DeliverableModel> _deliverables = [];
  String? _errorMinAmount;
  List<PointModel?> _points = [];
  double _totalPointAmount = 0.0;
  late bool _systemTermsAndConditions = false;
  late bool _systemPrivacyPolicy = false;
  late DateTime? _lastUpdate = DateTime.now();

  final FocusNode _focusNodeInputDni = FocusNode();
  final FocusNode _focusNodeInputName = FocusNode();
  final FocusNode _focusNodeInputSurname = FocusNode();
  final FocusNode _focusNodeInputAddress = FocusNode();
  final FocusNode _focusNodeInputEmail = FocusNode();
  final FocusNode _focusNodeInputPhone = FocusNode();
  final FocusNode _focusNodeInputInvoiceID = FocusNode();
  final FocusNode _focusNodeInputInvoiceTotalAmount = FocusNode();
  final FocusNode _focusNodeInputInvoiceIssueDate = FocusNode();

  String? _dateErrorText;
  bool datesValid = false;
  late IEventViewModel eventViewModel;
  late ICommerceViewModel commerceViewModel;
  late IClientViewModel clientViewModel;
  late IConditionsPoliciesViewModel conditionsPoliciesViewModel;
  late IPointsViewModel pointsViewModel;

  Future<void> _loadClientInfo(String dni) async {
    await clientViewModel.fetchClient(dni);

    if (clientViewModel.client != null) {
      setState(() {
        _existClient = true;
        _dniController.text = dni;
        _nameController.text = clientViewModel.client!.firstName;
        _surnameController.text = clientViewModel.client!.lastName;
        _addressController.text = clientViewModel.client!.address;
        _emailController.text = clientViewModel.client!.email;
        _phoneController.text = clientViewModel.client!.phone;
        _isMale = clientViewModel.client!.gender;
        _systemPrivacyPolicy = clientViewModel.client!.systemPrivacyPolicy!;
        _systemTermsAndConditions = clientViewModel.client!.systemTermsAndConditions!;
        _existClient = true;
        _lastUpdate = clientViewModel.client!.updateAt;
      });
    } else {
      setState(() {
        _lastUpdate = null;
        _dniController.text = dni;
        _existClient = false;
      });
    }
  }

  Future<void> _loadEventInfo(int eventId) async {
    await eventViewModel.loadEventInfo(eventId);
  }

  Future<void> _loadCommerces(int eventId) async {
    await commerceViewModel.loadCommerces(eventId);
  }

  Future<void> _generateDeliverableKits(InvoiceModel invoice) async {
    try {
      await context.read<IInvoiceViewModel>().createInvoiceKit(invoice);
      if (!mounted) return;
      List<DeliverableKitModel> kits = context
          .read<IInvoiceViewModel>()
          .deliverableKits;
      int quantity = kits.first.quantity;

      if (kits.first.id == 0) {
        await _showPopup(context, true, 'Factura registrada. Se generaron puntos.');
      } else {
        await _showPopup(
          context,
          true,
          quantity > 1 ? 'Factura registrada. Por favor, entrega $quantity kits al cliente.' : 'Factura registrada. Por favor, entrega un kit al cliente.',
        );
      }
      if (!mounted) return;
      setState(() {
        _clearInputsInvoice();
      });
    } catch (e) {
      if (!mounted) return;
      await _showPopup(context, false, e.toString());
      if (!mounted) return;
      setState(() {
        _totalPaid = 0.00;
      });
    }
  }

  Future<void> _generateDeliverables(InvoiceModel invoice) async {
    try {
      await context.read<IInvoiceViewModel>().createInvoice(invoice);
      if (!mounted) return;

      setState(() {
        _deliverables = context
            .read<IInvoiceViewModel>()
            .deliverables;
      });

      await _showPopup(
          context, true,
          _deliverables.isNotEmpty
              ? _deliverables.length > 1 ? 'Factura registrada. Se generaron ${_deliverables.length} cupones.' : 'Factura registrada. Se generó un cupón.'
              : 'Factura registrada. Se generaron puntos.');

      if (mounted) {
        if (_deliverables.isNotEmpty) {
          _printAllInvoices(_deliverables);
        }

        setState(() {
          _clearInputsInvoice();
        });
      }
    } catch (e) {
      if (mounted) {
        await _showPopup(context, false, e.toString());

        setState(() {
          _totalPaid = 0.00;
        });
      }
    }
  }

  Future<void> _printAllInvoices(List<DeliverableModel> deliverables) async {
    final font = await rootBundle.load("fonts/Poppins-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final image = await imageFromAssetBundle('assets/images/PSF_Logo_Printer.png');

    // Crear un solo documento PDF
    final pdf = pw.Document();

    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(now);
    final formattedTime = DateFormat('HH:mm:ss').format(now);

    // Para cada ticket, agregamos una página al documento
    for (var delivery in deliverables) {
      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(80 * PdfPageFormat.mm, 297 * PdfPageFormat.mm),
          build: (pw.Context context) {
            return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 5 * PdfPageFormat.mm),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 12),
                    pw.Center(
                      child: pw.Image(image),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Center(
                      child: pw.Text('Ticket #: ${delivery.ticketNumber}', style: pw.TextStyle(font: ttf, fontSize: 12)),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Nombre: ${_nameController.text} ${_surnameController.text}',
                      style: pw.TextStyle(font: ttf, fontSize: 10),
                    ),
                    pw.Text(
                      'Teléfono: ${_phoneController.text}',
                      style: pw.TextStyle(font: ttf, fontSize: 10),
                    ),
                    pw.Text('Fecha: $formattedDate', style: pw.TextStyle(font: ttf, fontSize: 10)),
                    pw.Text('Hora: $formattedTime', style: pw.TextStyle(font: ttf, fontSize: 10)),
                  ],
                ));
          },
        ),
      );
    }

    // Guardar el archivo PDF en una ubicación temporal
    final file = File('combined_invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    // Imprimir el PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // Eliminar el archivo PDF después de la impresión
    await file.delete();
  }

  Future<pw.ImageProvider> imageFromAssetBundle(String path) async {
    final imageData = await rootBundle.load(path);
    final buffer = imageData.buffer.asUint8List();
    return pw.MemoryImage(buffer);
  }

  void _loadPaymentMethods() async {
    final paymentViewModel = context.read<IPaymentTypeViewModel>();
    await paymentViewModel.loadPaymentTypes();
    setState(() {
      _availablePaymentMethods = paymentViewModel.paymentTypeName;
    });
  }

  void _updateTotalPaid() {
    setState(() {
      _totalPaid = _paymentMethodsSelected.fold(0.0, (sum, pm) => sum + pm.amountPayment);
    });
  }

  List<String> _getRemainingMethods(int index) {
    List<String?> selectedMethods = _paymentMethodsSelected.map((pm) => pm.namePayment).toList();
    if (index >= 0 && index < selectedMethods.length) {
      selectedMethods.removeAt(index);
    }
    return _availablePaymentMethods.where((method) => !selectedMethods.contains(method)).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )
      ..repeat(reverse: false);
    _eventName.text = widget.nameEvent!;

    context.read<IInvoiceViewModel>();

    clientViewModel = context.read<IClientViewModel>();

    eventViewModel = context.read<IEventViewModel>();
    eventViewModel.minAmount;

    commerceViewModel = context.read<ICommerceViewModel>();
    commerceViewModel.loadCommerces(widget.eventId!);

    conditionsPoliciesViewModel = context.read<IConditionsPoliciesViewModel>();
    pointsViewModel = context.read<IPointsViewModel>();

    _loadPaymentMethods();
    _dniController.text = widget.dni!;
    _loadClientInfo(_dniController.text);

    _eventID = widget.eventId!;

    _invoiceIssueDateController.addListener(() {
      _validateForm();
    });
    _documentTypeIsCedula = widget.documentTypeIsCedula!;
    _loadPoints();
  }

  void _validateForm() {
    setState(() {
      final String invoiceIssueDate = _invoiceIssueDateController.text;

      if (invoiceIssueDate.length >= 8 && !RegexUtils.isValidDate(invoiceIssueDate)) {
        _dateErrorText = 'Ingrese la fecha en el formato correcto';
        datesValid = false;
      } else {
        try {
          final startDate = DateTime.parse(invoiceIssueDate);

          if (startDate.isAfter(DateTime.now())) {
            _dateErrorText = 'La fecha no puede ser mayor a la actual';
            datesValid = false;
          } else {
            _dateErrorText = null;
            datesValid = true;
          }
        } catch (e) {
          datesValid = false;
        }
      }
    });

    if (_invoiceIssueDateController.text.isEmpty) {
      _dateErrorText = null;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _dniController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _eventName.dispose();
    _commerceController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
    _loadPoints();
  }

  bool get _validateFirstForm {
    return _dniController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _surnameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _isEmailValid &&
        _phoneController.text.length == 10 &&
        _systemTermsAndConditions &&
        _systemPrivacyPolicy;
  }

  bool get _validateAmount {
    return _totalPaid == _totalAmount ? true : false;
  }

  bool get _validateSecondForm {
    bool allPaymentMethodsValid = _paymentMethodsSelected.isNotEmpty && _paymentMethodsSelected.every((paymentMethod) => paymentMethod.namePayment!.isNotEmpty);
    return _commerceController.text.isNotEmpty &&
        _validateAmount &&
        _invoiceIDController.text.isNotEmpty &&
        _invoiceIssueDateController.text.isNotEmpty &&
        allPaymentMethodsValid &&
        _eventName.text.isNotEmpty &&
        _invoiceIDController.text.length == 17 &&
        _invoiceIssueDateController.text.length == 10;
  }

  void _clearForm() {
    _dniController.clear();
    _nameController.clear();
    _surnameController.clear();
    _addressController.clear();
    _emailController.clear();
    _phoneController.clear();
    _commerceController.clear();
    _invoiceIssueDateController.clear();
    datesValid = false;
    _singleSelectionDropBoxInvoiceKey.currentState?.clearCustomSingleSelectionDropBoxStateInputs();

    if (widget.numberEvents! > 1) {
      _eventName.clear();
    }

    setState(() {
      _isMale = true;
      _existClient = false;
      _systemPrivacyPolicy = false;
      _systemTermsAndConditions = false;
      _totalPointAmount = 0.0;
    });
    pointsViewModel.points.clear();
    _eventID = 0;
  }

  final GlobalKey<CustomSingleSelectionDropBoxState> _singleSelectionDropBoxInvoiceKey = GlobalKey<CustomSingleSelectionDropBoxState>();

  void _clearInputsInvoice() {
    _singleSelectionDropBoxInvoiceKey.currentState?.clearCustomSingleSelectionDropBoxStateInputs();
    _totalAmountController.clear();
    _invoiceIssueDateController.clear();
    _eventName.clear();
    _errorMinAmount = null;
    _invoiceIDController.clear();
    _totalPaid = 0.00;
    _totalPointAmount = 0.00;
    _totalAmount = 0.00;
  }

  void _loadPoints() async {
    pointsViewModel.points.clear();
    await pointsViewModel.loadPoints(_dniController.text, _eventID);
    _totalPointAmount = 0.0;
    setState(() {
      _points = pointsViewModel.points;
      for (var point in _points) {
        _totalPointAmount += point!.pointAmount;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Stack(
            children: [
              Container(
                height: size.height,
                decoration: BoxDecoration(
                  gradient: AppTheme().animatedRadialGradient(_animationController),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Text(
                              _eventName.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.025,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            onTap: () async {
                              conditionsPoliciesViewModel.getEventTermsAndConditions(_eventID);
                              if (!mounted) return;
                              _showPopupInfo(context, conditionsPoliciesViewModel.eventTermsAndConditionsContent!);
                            },
                          )
                        ],
                      ),
                    ),
                    dataClientAndInvoice(),
                  ],
                ),
              ),
              CustomTopLeftButton(
                icon: Icons.arrow_back_ios_new,
                text: 'Cédula / Pasaporte',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ClientDniScreen(
                                numberEvents: widget.numberEvents,
                                nameEvent: _eventName.text,
                                eventId: _eventID,
                              )));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget dataClientAndInvoice() {
    final size = MediaQuery
        .of(context)
        .size;
    final clientViewModel = context.watch<IClientViewModel>();

    context.watch<IInvoiceViewModel>();
    return Expanded(
      flex: 1,
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  width: size.width * 0.35,
                  height: size.height * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(size.width * 0.008 * 2.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.height * 0.05,
                    ),
                    child: SingleChildScrollView(
                      child: FocusTraversalGroup(
                        policy: OrderedTraversalPolicy(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DNIField(
                              controller: _dniController,
                              readOnly: _dniController.text.length == 10 && _documentTypeIsCedula == true ? true : false,
                              focusNode: _focusNodeInputDni,
                              autofocus: true,
                              onFieldSubmited: (_) => _focusNodeInputName.requestFocus(),
                              labelText: _documentTypeIsCedula == true ? 'Cédula' : 'Pasaporte',
                              hintText: 'Ingrese ${_documentTypeIsCedula == true ? 'Cédula' : 'Pasaporte'}',
                              mainColor: Colors.white,
                              isCedula: _documentTypeIsCedula,
                              onChanged: (p0) {
                                _loadClientInfo(_dniController.text);
                              },
                            ),
                            SizedBox(height: size.height * 0.015),
                            Row(
                              children: [
                                Expanded(
                                  child: ElegantTextField(
                                    controller: _nameController,
                                    focusNode: _focusNodeInputName,
                                    onFieldSubmitted: (_) => _focusNodeInputSurname.requestFocus(),
                                    labelText: 'Nombre',
                                    hintText: 'Ingrese su nombre',
                                    mainColor: Colors.white,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20),
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚ\s]'),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.height * 0.015),
                                Expanded(
                                  child: ElegantTextField(
                                    controller: _surnameController,
                                    focusNode: _focusNodeInputSurname,
                                    onFieldSubmitted: (_) => _focusNodeInputAddress.requestFocus(),
                                    labelText: 'Apellido',
                                    hintText: 'Ingrese su apellido',
                                    mainColor: Colors.white,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20),
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.015),
                            ElegantTextField(
                              controller: _addressController,
                              focusNode: _focusNodeInputAddress,
                              onFieldSubmitted: (_) => _focusNodeInputEmail.requestFocus(),
                              labelText: 'Dirección',
                              hintText: 'Ingrese su dirección',
                              mainColor: Colors.white,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9.,\sáéíóúÁÉÍÓÚ]'),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.015),
                            ElegantTextField(
                              controller: _emailController,
                              focusNode: _focusNodeInputEmail,
                              onFieldSubmitted: (_) => _focusNodeInputPhone.requestFocus(),
                              labelText: 'Correo electrónico',
                              hintText: 'Ingrese su correo electrónico',
                              mainColor: Colors.white,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter.deny(RegExp('[ ]')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  _isEmailValid = false;
                                  return 'El correo no puede estar vacío';
                                } else {
                                  String pattern = r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
                                  RegExp regex = RegExp(pattern);
                                  if (!regex.hasMatch(value)) {
                                    _isEmailValid = false;
                                    return 'Ingresa un correo válido';
                                  } else {
                                    _isEmailValid = true;
                                  }
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: size.height * 0.015),
                            ElegantNumberField(
                              controller: _phoneController,
                              focusNode: _focusNodeInputPhone,
                              onFieldSubmited: (_) => _focusNodeInputInvoiceID.requestFocus(),
                              labelText: 'Teléfono',
                              hintText: 'Ingrese su número de teléfono',
                              mainColor: Colors.white,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.deny(RegExp('[ ]')),
                              ],
                            ),
                            SizedBox(height: size.height * 0.015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElegantCustomBoolSwitch(
                                  labelText: 'Género',
                                  option1: 'Masculino',
                                  option2: 'Femenino',
                                  defaultValue: _isMale,
                                  onChanged: (value) {
                                    setState(() {
                                      _isMale = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            //Privacy Checkbox
                            Container(
                              padding: EdgeInsets.only(top: size.height * 0.005),
                              child: CustomCheckBox(
                                isChecked: _systemPrivacyPolicy,
                                labelText: 'Acepto la ',
                                secondaryText: 'política de privacidad.',
                                onTap: (selected) {
                                  setState(() {
                                    selected == true ? _systemPrivacyPolicy = true : _systemPrivacyPolicy = false;
                                  });
                                },
                                onTapText: () {
                                  conditionsPoliciesViewModel.getPrivacyPolicies();
                                  if (!mounted) return;
                                  _showPopupInfo(context, conditionsPoliciesViewModel.privacyPolicyContent!);
                                },
                              ),
                            ),
                            //Terms Checkbox
                            CustomCheckBox(
                              isChecked: _systemTermsAndConditions,
                              labelText: 'Acepto los ',
                              secondaryText: 'términos y condiciones.',
                              onTap: (selected) {
                                setState(() {
                                  selected == true ? _systemTermsAndConditions = true : _systemTermsAndConditions = false;
                                });
                              },
                              onTapText: () {
                                conditionsPoliciesViewModel.getTermsAndConditions();
                                _showPopupInfo(context, conditionsPoliciesViewModel.termsAndConditionsContent!);
                              },
                            ),
                            SizedBox(height: size.height * 0.015),
                            Row(
                              children: [
                                Expanded(
                                  child: clientViewModel.isLoading
                                      ? const Center(child: CircularProgressIndicator())
                                      : SubmitButton(
                                    buttonText: _existClient ? 'Actualizar datos' : 'Registrar cliente',
                                    controllers: [
                                      _dniController,
                                      _nameController,
                                      _surnameController,
                                      _addressController,
                                      _emailController,
                                      _phoneController,
                                    ],
                                    validateEventForm: _validateFirstForm,
                                    onPressed: () async {
                                      if (_existClient == false) {
                                        final client = ClientModelRequest(
                                          dni: _dniController.text,
                                          typeId: _documentTypeIsCedula == true ? 'Cedula' : 'Pasaporte',
                                          address: _addressController.text,
                                          email: _emailController.text,
                                          firstName: _nameController.text,
                                          lastName: _surnameController.text,
                                          gender: _isMale,
                                          phone: _phoneController.text,
                                          systemPrivacyPolicy: _systemPrivacyPolicy,
                                          systemTermsAndConditions: _systemTermsAndConditions,
                                        );
                                        try {
                                          await clientViewModel.createClient(client);
                                          if (!mounted) return;
                                          _showPopup(context, true, 'Registro de datos del cliente exitoso');
                                          setState(() {
                                            _existClient = true;
                                          });
                                        } catch (e) {
                                          _showPopup(context, false, e.toString());
                                        }
                                      } else {
                                        final client = ClientModelRequest(
                                          dni: _dniController.text,
                                          typeId: _documentTypeIsCedula == true ? 'Cedula' : 'Pasaporte',
                                          address: _addressController.text,
                                          email: _emailController.text,
                                          firstName: _nameController.text,
                                          lastName: _surnameController.text,
                                          gender: _isMale,
                                          phone: _phoneController.text,
                                          systemPrivacyPolicy: _systemPrivacyPolicy,
                                          systemTermsAndConditions: _systemTermsAndConditions,
                                        );
                                        try {
                                          await clientViewModel.updateClient(client);
                                          if (!mounted) return;
                                          _showPopup(context, true, 'Actualización de datos del cliente exitosa');
                                        } catch (e) {
                                          _showPopup(context, false, e.toString());
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: size.height * 0.015),
                                Expanded(
                                  child: InkWell(
                                    onTap: _clearForm,
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
                            ),
                            SizedBox(height: size.height * 0.015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _totalPointAmount > 0 ? 'Puntos acumulados: ${_totalPointAmount.toStringAsFixed(2)}' : 'Sin puntos registrados',
                                  style: TextStyle(fontFamily: 'Poppins', fontSize: size.height * 0.02),
                                ),
                                SizedBox(width: size.height * 0.015),
                                Visibility(
                                  visible: _totalPointAmount > 0,
                                  child: SizedBox(
                                    child: InkWell(
                                      onTap: () {
                                        String message = (_points.map((e) => '• ${e!.invoicePaymentName} = ${e.pointAmount.toStringAsFixed(2)} ptos').join('\n'));
                                        _showPopupPoints(context, message);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Ver puntos',
                                              style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height * 0.02)),
                                          const Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: size.height * 0.015),
                            _lastUpdate != null
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Última actualización de datos: ${_lastUpdate
                                    .toString()
                                    .split('.')
                                    .first
                                    .replaceFirst('T', ' ')}',
                                    style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.02)),
                              ],
                            )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  width: size.width * 0.35,
                  height: size.height * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(size.width * 0.008 * 2.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.height * 0.05,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Consumer<IEventViewModel>(builder: (context, eventViewModel, child) {
                            return CustomSingleSelectionDropBox(
                              key: _singleSelectionDropBoxInvoiceKey,
                              items: eventViewModel.getActiveEventsObjects(),
                              onChanged: (selectedItem) async {
                                if (widget.numberEvents == 1) {
                                  setState(() {
                                    _eventName.text = eventViewModel.getActiveEventsObjects()[0].name;
                                    _eventID = eventViewModel.getActiveEventsObjects()[0].id;
                                  });
                                }

                                if (selectedItem != null) {
                                  _eventID = selectedItem.id;
                                  await _loadCommerces(_eventID);
                                  await _loadEventInfo(_eventID);

                                  setState(() {
                                    _eventName.text = selectedItem.name;
                                    _eventID = selectedItem.id;
                                    _commerceController.clear();
                                    _loadPoints();
                                  });
                                }
                              },
                              labelText: _eventName.text.isEmpty ? 'Seleccione el evento' : _eventName.text,
                              hintText: 'Seleccione el evento',
                              displayValue: (event) => event.name,
                            );
                          }),
                          if (_eventName.text.isNotEmpty) ...[
                            SizedBox(height: size.height * 0.015),
                            Consumer<ICommerceViewModel>(builder: (context, commerceViewModel, child) {
                              return commerceViewModel.commerces.isEmpty
                                  ? const CircularProgressIndicator()
                                  : CustomSearchWidget(
                                controller: _commerceController,
                                items: commerceViewModel.commerces.map((commerce) => commerce.razonSocial).toList(),
                                onItemSelected: (selectedItem) {
                                  setState(() {
                                    final selectedCommerce = commerceViewModel.commerces.firstWhere(
                                          (commerce) => commerce.razonSocial == selectedItem,
                                    );
                                    _commerceController.text = selectedCommerce.razonSocial;
                                    _commerceId = selectedCommerce.id;
                                  });
                                },
                              );
                            }),
                            SizedBox(height: size.height * 0.015),
                            ElegantTextField(
                              controller: _invoiceIDController,
                              focusNode: _focusNodeInputInvoiceID,
                              onFieldSubmitted: (_) => _focusNodeInputInvoiceTotalAmount.requestFocus(),
                              labelText: 'Número de factura',
                              hintText: 'Ingrese su número de factura',
                              mainColor: Colors.white,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(17),
                                FilteringTextInputFormatter.digitsOnly,
                                InvoiceNumberInputFormatter(),
                              ],
                            ),
                            SizedBox(height: size.height * 0.015),
                            ElegantTextField(
                              controller: _totalAmountController,
                              labelText: 'Monto total',
                              hintText: 'Ingrese el monto de su factura',
                              focusNode: _focusNodeInputInvoiceTotalAmount,
                              onFieldSubmitted: (_) => _focusNodeInputName.requestFocus(),
                              mainColor: Colors.white,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^(?!0)\d*\.?\d*$')),
                                DecimalTextInputFormatter(decimalRange: 2),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    try {
                                      _totalAmount = double.parse(value);
                                    } catch (e) {
                                      _totalAmount = 0.0;
                                    }
                                  }
                                  _updateTotalPaid();
                                });
                              },
                              errorText: _errorMinAmount,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  _errorMinAmount = 'Ingrese el monto total de la factura';
                                  return _errorMinAmount;
                                }

                                final amount = double.parse(value);

                                if (amount == 0) {
                                  _errorMinAmount = 'Ingrese un monto válido';
                                  return _errorMinAmount;
                                } else {
                                  _errorMinAmount = null;
                                  return _errorMinAmount;
                                }
                              },
                            ),
                            SizedBox(height: size.height * 0.015),
                            ElegantDatePickerFormField(
                              controller: _invoiceIssueDateController,
                              focusNode: _focusNodeInputInvoiceIssueDate,
                              onFieldSubmited: (_) => _focusNodeInputDni.requestFocus(),
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now(),
                              labelText: 'Fecha de emisión',
                              onValidationChanged: (_) => _validateForm(),
                              hintText: 'Ingrese la fecha (yyyy-mm-dd)',
                              errorText: _dateErrorText,
                              inputFormatters: [LengthLimitingTextInputFormatter(10)],
                            ),
                            SizedBox(height: size.height * 0.015),
                            SizedBox(
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _paymentMethodsSelected.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _paymentMethodsSelected.length) {
                                      bool canAddPaymentMethod =
                                          _totalPaid < _totalAmount && (_paymentMethodsSelected.isEmpty || _paymentMethodsSelected.last.namePayment!.isNotEmpty);

                                      return InkWell(
                                        onTap: canAddPaymentMethod
                                            ? () {
                                          setState(() {
                                            _paymentMethodsSelected.add(InvoicePaymentModel(namePayment: '', amountPayment: 0));
                                          });
                                        }
                                            : null,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: canAddPaymentMethod ? const Color.fromRGBO(79, 20, 107, 1.0) : const Color.fromRGBO(47, 79, 79, 0.363),
                                            borderRadius: BorderRadius.circular(size.width * 0.008),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Agregar método de pago',
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: size.height * 0.022,
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return PaymentMethodWidget(
                                        paymentMethod: _paymentMethodsSelected[index],
                                        availableMethods: _getRemainingMethods(index),
                                        onRemove: () {
                                          setState(() {
                                            _paymentMethodsSelected.removeAt(index);
                                            _updateTotalPaid();
                                          });
                                        },
                                        onAmountChanged: (value) {
                                          _updateTotalPaid();
                                        },
                                        onMethodChanged: (value) {
                                          setState(() {
                                            _paymentMethodsSelected[index].namePayment = value;
                                          });
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.015),
                            SizedBox(
                              height: size.height * 0.06,
                              width: double.infinity,
                              child: clientViewModel.isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : SubmitButton(
                                buttonText: 'Registrar factura',
                                controllers: [_eventName, _invoiceIDController, _invoiceIssueDateController, _commerceController, _invoiceIssueDateController],
                                validateEventForm: _validateSecondForm,
                                onPressed: () async {
                                  final invoice = InvoiceModel(
                                      numberInvoice: _invoiceIDController.text,
                                      msClientClientDni: _dniController.text,
                                      msEventEventId: _eventID,
                                      amount: _totalAmount,
                                      dateEmission: DateTime.parse(_invoiceIssueDateController.text),
                                      msEventCommerceid: _commerceId,
                                      invoicePaymentsWithNames: _paymentMethodsSelected,
                                      invoiceEventConditions: EventConditionsModel(
                                          isDinnersTripleCupon: context
                                              .read<IEventViewModel>()
                                              .vipStatus,
                                          minAmount: context
                                              .read<IEventViewModel>()
                                              .minAmount,
                                          maxAmount: context
                                              .read<IEventViewModel>()
                                              .maxAmount,
                                          deliveryType: context
                                              .read<IEventViewModel>()
                                              .deliveryType));

                                  context
                                      .read<IEventViewModel>()
                                      .deliveryType == 'TICKET'
                                      ? await _generateDeliverables(invoice)
                                      : await _generateDeliverableKits(invoice);
                                  _paymentMethodsSelected.clear();
                                },
                                backgroundColor: _totalPaid == _totalAmount ? const Color.fromRGBO(79, 20, 107, 1.0) : Colors.grey,
                              ),
                            ),
                            SizedBox(height: size.height * 0.015),
                            Text(
                              'Total Pagado: ${_totalPaid.toStringAsFixed(2)} / Total Factura: ${_totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopupPoints(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassPopupDisplayInfo(
          title: 'Puntos acumulados',
          message: message,
        );
      },
    );
  }

  Future<void> _showPopup(BuildContext context, bool isSuccess, String message) async {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassPopup(
          icon: isSuccess ? Icons.check_circle : Icons.warning,
          message: isSuccess ? message : message,
        );
      },
    );
  }

  void _showPopupInfo(BuildContext context, String message) {
    final size = MediaQuery
        .of(context)
        .size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassPopup(
          isExpanded: true,
          heightPersonalized: size.height * 0.9,
          widthPersonalized: size.width * 0.45,
          fontSizePersonalized: size.height * 0.022,
          textAlignPersonalized: TextAlign.start,
          icon: FontAwesomeIcons.circleInfo,
          message: message,
        );
      },
    );
  }
}

class InvoiceNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > 3) {
      digitsOnly = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
    }
    if (digitsOnly.length > 7) {
      digitsOnly = '${digitsOnly.substring(0, 7)}-${digitsOnly.substring(7)}';
    }
    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}
