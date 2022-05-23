
import 'package:table_calendar/table_calendar.dart';

extension Range on DateTime {
  bool isAndInRange({required DateTime start, required DateTime end}) {
    return isSameDay(this, start) || isSameDay(this, end) || (isAfter(start) && isBefore(end));
  }
}