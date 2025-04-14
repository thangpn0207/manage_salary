import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MoneyInputFormatter extends TextInputFormatter {
  final NumberFormat _displayFormatter = NumberFormat.simpleCurrency(locale: "vi_VN");
  final NumberFormat _editFormatter = NumberFormat("#,###", "vi_VN");
  
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If backspace is pressed, remove one character
    if (oldValue.text.length > newValue.text.length) {
      final String strippedValue = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
      if (strippedValue.isEmpty) return TextEditingValue(text: '');
      
      final double value = double.parse(strippedValue);
      final String formatted = _editFormatter.format(value);
      
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Only allow digits
    String filteredText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (filteredText.isEmpty) return TextEditingValue(text: '');

    double value = double.parse(filteredText);
    String formatted = _editFormatter.format(value);

    // Keep cursor at proper position
    int selectionIndex = formatted.length;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  // Helper method to format for display (with currency symbol)
  String formatForDisplay(String text) {
    if (text.isEmpty) return '';
    final String strippedValue = text.replaceAll(RegExp(r'[^\d]'), '');
    if (strippedValue.isEmpty) return '';
    return _displayFormatter.format(double.parse(strippedValue));
  }
}
