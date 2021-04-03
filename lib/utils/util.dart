import 'package:work_hour_tracker/generated/l10n.dart';

class Util {
  static String formatDuration(Duration duration, {bool addSign = false}) {
    var buffer = StringBuffer();
    if (addSign) {
      buffer.write(duration.isNegative ? '-' : '+');
    }

    duration = Duration(milliseconds: duration.inMilliseconds.abs());

    var hours = duration.inHours.remainder(60);
    var minutes = duration.inMinutes.remainder(60);
    var seconds = duration.inSeconds.remainder(60);

    if (seconds > 0) minutes++;

    buffer.write(hours > 0 ? '$hours${S.current.hour_unit} ' : '');
    buffer.write(minutes > 0 ? '$minutes${S.current.minute_unit}' : '');

    return buffer.toString().padLeft(7, ' ');
  }
}
