import 'package:intl/intl.dart';

final _calendarDateFormat = DateFormat('dd.MM.yyyy');

extension DateTimeExt on DateTime {
  String toCalendarDate() => _calendarDateFormat.format(this);

  static DateTime fromCalenderDate(String s) => _calendarDateFormat.parse(s);
}

DateTime? minDateTime(DateTime? d1, DateTime? d2) {
  if (d1 == null) {
    return d2;
  } else if (d2 == null) {
    return d1;
  } else if (d1.isBefore(d2)) {
    return d1;
  } else {
    return d2;
  }
}
