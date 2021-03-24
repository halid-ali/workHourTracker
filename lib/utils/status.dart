import 'package:work_hour_tracker/generated/l10n.dart';

enum Status {
  none,
  running,
  stopped,
  paused,
}

extension StatusExtension on Status {
  String get value => this.toString().split('.').last;
}

Status statusFromString(String value) {
  switch (value) {
    case 'none':
      return Status.none;
    case 'running':
      return Status.running;
    case 'stopped':
      return Status.stopped;
    case 'paused':
      return Status.paused;
    default:
      throw StatusException(S.current.status_exception_message);
  }
}

class StatusException implements Exception {
  String reason;
  StatusException(this.reason);
}
