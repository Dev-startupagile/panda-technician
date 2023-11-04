import 'package:intl/intl.dart';

String getUsDateFormat(String date) {
  try {
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(now);

    if (formatted.split("-").length > 0) {
      return formatted.split("-").join("/");
    } else {
      return formatted;
    }
  } catch (_) {
    return date;
  }
}

String changeToAmPm(String time) {
  try {
    final DateTime now = DateTime.parse(time);
    final DateFormat formatter = DateFormat('hh:mm a');
    final String formatted = formatter.format(now);

    return formatted;
  } catch (_) {
    return time;
  }
}
