import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeAgoService {
  timeAgoFormatting(String time) {
    final timeAgoFormatted = DateTime.parse(time);

    // Add a new locale messages
    timeago.setLocaleMessages('id', timeago.IdMessages());
    var timeFormated = timeago.format(timeAgoFormatted, locale: 'id');
    return timeFormated;
  }
}
