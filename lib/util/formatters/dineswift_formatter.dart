import 'package:intl/intl.dart';

class DineSwiftFormatter {

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String phoneNumber(String phone) {
    if (phone.length == 10) {
      return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
    } else if (phone.length == 11 && phone.startsWith('1')) {
      return '+1 (${phone.substring(0, 4)}) ${phone.substring(4, 7)}-${phone.substring(7)}';
    }
    return phone; // Return as is if format is unrecognized
  }

  // static String internationalFormatPhoneNumber(String phoneNumber) {
  //   var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
  //   String countryCode = '+${digitsOnly.substring(0, 2)}';
  //   String mainNumber = digitsOnly.substring(2);

  //   final formattedNumber = StringBuffer();
  //   formattedNumber.write('($countryCode) ');

  //   int i = 0;
  //   while (i < mainNumber.length) {
  //     int groupLength = 2;
  //     if (i == 0 && countryCode == '+1') {
  //       groupLength = 3;
  //     }

  //     int end = i + groupLength;
  //     formattedNumber.write(mainNumber.substring(i, end));

  //     if (end < mainNumber.length) {
  //       formattedNumber.write('-');
  //     }

  //     i = end;
  //   }
  // }

  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(2)}%';
  }
}