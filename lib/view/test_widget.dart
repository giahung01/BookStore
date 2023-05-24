import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
class TestWidget extends StatelessWidget {


  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController imgLinkController = TextEditingController();
    return Scaffold(
      body: TextField(
        controller: imgLinkController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CurrencyInputFormatter(),
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: 'Giá',
        ),
      ),

    );
  }



}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final numericValue = int.tryParse(newValue.text);

    if (numericValue != null) {
      final formattedValue = currencyFormat.format(numericValue);
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }

    return newValue;
  }
}


