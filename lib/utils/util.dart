import 'package:work_hour_tracker/generated/l10n.dart';

class Util {
  static String formatDuration(
    Duration duration, {
    bool addSign = false,
    bool padLeft = true,
  }) {
    var buffer = StringBuffer();
    var isNegative = duration.isNegative;

    if (addSign) {
      buffer.write(isNegative ? '-' : '+');
    }

    duration = Duration(milliseconds: duration.inMilliseconds.abs());

    var hours = duration.inHours.remainder(60);
    var minutes = duration.inMinutes.remainder(60);
    var seconds = duration.inSeconds.remainder(60);

    if (seconds > 0 && !isNegative) minutes++;

    buffer.write(hours > 0 ? '$hours${S.current.hour_unit} ' : '');
    buffer.write(minutes > 0 ? '$minutes${S.current.minute_unit}' : '');

    var result = buffer.toString().isEmpty ? '0m' : buffer.toString();
    result = padLeft ? result.padLeft(7, ' ') : result.padRight(7, ' ');

    return result;
  }
}
