import 'package:intl/intl.dart';

class TimeFormat {
  static String formatDate(DateTime? date, {bool? exact}) {
    if (date == null) {
      return "No Due Date.";
    }

    if (exact == true) {
      var buffer = StringBuffer();

      buffer.write(date.hour.toString().padLeft(2, '0'));
      buffer.write(":");
      buffer.write(date.minute.toString().padLeft(2, '0'));
      buffer.write(" - ");
      buffer.write(date.year.toString().padLeft(4, '0'));
      buffer.write("/");
      buffer.write(date.month.toString().padLeft(2, '0'));
      buffer.write("/");
      buffer.write(date.day.toString().padLeft(2, '0'));

      return buffer.toString();
    }

    var now = DateTime.now();
    var time = DateFormat.Hm().format(date);

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today at $time';
    }
    if (date.day == now.day + 1 &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Tomorrow at $time';
    }
    if (date.year == now.year) {
      if (date.month == now.month) {
        int weekDifference = (date.difference(now).inDays / 7).ceil();
        if (weekDifference <= 1) {
          return 'Next week at $time';
        }
        if (weekDifference <= 4) {
          return 'In $weekDifference weeks at $time';
        }
        if (date.day >= now.day && date.day < now.day + 7) {
          return '${DateFormat.EEEE().format(date)} at $time';
        }
      }
      if (date.month == now.month + 1) {
        return 'Next month at $time';
      }
      return '${DateFormat.MMMM().format(date)} at $time';
    }
    if (date.year == now.year + 1) {
      return 'Next year at $time';
    }
    return '${DateFormat.d().format(date)} ${DateFormat.MMMM().format(date)} ${DateFormat.y().format(date)}';
  }
}