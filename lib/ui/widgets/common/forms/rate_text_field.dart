import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RateTextField extends StatelessWidget {
  RateTextField({
    super.key,
    this.onChanged,
    this.initialValue = 0,
  });

  final void Function(int)? onChanged;
  final int initialValue;

  final _formatter = CurrencyTextInputFormatter(
    locale: 'en_US',
    decimalDigits: 2,
    symbol: '',
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _formatter.format(initialValue.toString()),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.attach_money),
        labelText: 'Price',
        prefixText: r'$ ',
      ),
      inputFormatters: <TextInputFormatter>[_formatter],
      keyboardType: TextInputType.number,
      onChanged: (input) {
        final value = _formatter.getUnformattedValue().toDouble();
        final usdValue = (value * 100).toInt();

        onChanged?.call(usdValue);
      },
    );
  }
}
