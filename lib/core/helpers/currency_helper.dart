import 'package:intl/intl.dart';

String formatRupiah(int amount) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
}

int removeDot(String value) {
  return int.parse(value.replaceAll('.', ''));
}