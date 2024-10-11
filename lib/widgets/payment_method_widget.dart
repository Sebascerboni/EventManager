import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_project/models/invoice/invoice_payment_model.dart';
import 'package:forms_project/widgets/custom_input_number_field_widget.dart';
import 'custom_single_selection_drop_box_widget.dart';

class PaymentMethodWidget extends StatefulWidget {
  final InvoicePaymentModel paymentMethod;
  final List<String> availableMethods;
  final VoidCallback onRemove;
  final ValueChanged<double> onAmountChanged;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodWidget({
    super.key,
    required this.paymentMethod,
    required this.availableMethods,
    required this.onRemove,
    required this.onAmountChanged,
    required this.onMethodChanged,
  });

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.015,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomSingleSelectionDropBox<String>(
              items: widget.availableMethods,
              labelText: 'Método de pago',
              hintText: 'Selecciona un método',
              displayValue: (method) => method,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    widget.paymentMethod.namePayment = newValue;
                    widget.onMethodChanged(newValue);
                  });
                }
              },
            ),
          ),
          SizedBox(width: size.height * 0.015),
          Expanded(
            child: ElegantNumberField(
              labelText: 'Monto abonado',
              hintText: 'Ingrese el monto',
              mainColor: Colors.white,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(?!0)\d*\.?\d*$')),
                DecimalTextInputFormatter(decimalRange: 2),
              ],
              onChanged: (value) {
                try {
                  widget.paymentMethod.amountPayment = double.parse(value);
                } catch (e) {
                  widget.paymentMethod.amountPayment = 0.0;
                }
                widget.onAmountChanged(widget.paymentMethod.amountPayment);
              },
            ),
          ),
          SizedBox(width: size.height * 0.015),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}
