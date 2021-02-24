import 'dart:math';

import 'package:work_hour_tracker/classes/status.dart';

class WorkHourSlot {
  final String option;
  DateTime _startTime;
  DateTime _stopTime;
  DateTime _breakTime;
  Duration _breakDuration = Duration.zero;
  Duration _workDuration = Duration.zero;

  Status _status = Status.none;

  WorkHourSlot(this.option);

  WorkHourSlot.withSampleData(this.option) {
    var totalDuration = Duration(seconds: Random().nextInt(1000));
    _startTime = DateTime.now();
    _stopTime = DateTime.now().add(totalDuration);
    _breakDuration =
        Duration(seconds: Random().nextInt(totalDuration.inSeconds));
    _workDuration = totalDuration - _breakDuration;
    _status = Status.stopped;
  }

  DateTime get startTime => _startTime;

  DateTime get stopTime => _stopTime;

  Duration get breakDuration => _breakDuration;

  Duration get workDuration => _getWorkDuration();

  bool get isStarted => _status == Status.running;

  bool get isStopped => _status == Status.stopped;

  bool get isPaused => _status == Status.paused;

  Status get status => _status;

  void start() {
    if (_status == Status.none) {
      _startTime = DateTime.now();
    } else if (_status == Status.paused) {
      _breakDuration += DateTime.now().difference(_breakTime);
    }

    _status = Status.running;
  }

  void stop() {
    _stopTime = DateTime.now();

    if (_status == Status.paused) {
      _breakDuration += _stopTime.difference(_breakTime);
    }

    _workDuration = _stopTime.difference(_startTime) - _breakDuration;
    _status = Status.stopped;
  }

  void pause() {
    _breakTime = DateTime.now();
    _workDuration = _breakTime.difference(_startTime) - _breakDuration;
    _status = Status.paused;
  }

  Duration _getWorkDuration() {
    if (_status == Status.running) {
      return DateTime.now().difference(_startTime) - _breakDuration;
    }

    return _workDuration;
  }
}
