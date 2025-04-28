import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    final format = NumberFormat.simpleCurrency(decimalDigits: 2);
    return format.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }
}
