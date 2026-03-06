import 'package:intl/intl.dart';

final NumberFormat _vndFormatter = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'VND ',
  decimalDigits: 0,
);

String formatVnd(num amount) {
  return _vndFormatter.format(amount);
}
