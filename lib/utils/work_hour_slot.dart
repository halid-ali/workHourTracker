import 'package:work_hour_tracker/data/repo/slot_repo.dart';
import 'package:work_hour_tracker/utils/status.dart';
import 'package:work_hour_tracker/data/model/slot_model.dart';

class WorkHourSlot {
  final String userId;
  final String optionId;

  SlotModel workSlot;

  WorkHourSlot(this.userId, this.optionId) {
    workSlot = SlotModel(userId: userId, optionId: optionId);
  }

  WorkHourSlot.fromSlot(SlotModel existingSlot)
      : userId = existingSlot.userId,
        optionId = existingSlot.optionId {
    workSlot = existingSlot;
  }

  DateTime get startTime => workSlot.startTime;

  DateTime get stopTime => workSlot.stopTime;

  Duration get pauseDuration => Duration(milliseconds: workSlot.pauseDuration);

  Duration get workDuration => getWorkDuration();

  Status get status => statusFromString(workSlot.timerStatus);

  void start() {
    if (status == Status.none) {
      workSlot.startTime = DateTime.now();
      workSlot.timerStatus = Status.running.value;
      SlotRepository.addWorkHourSlot(workSlot);
    } else if (status == Status.paused) {
      workSlot.timerStatus = Status.running.value;
      workSlot.pauseDuration +=
          DateTime.now().difference(workSlot.pauseTime).inMilliseconds;
      SlotRepository.updateWorkHourSlot(workSlot);
    }
  }

  void stop() {
    workSlot.stopTime = DateTime.now();

    if (status == Status.paused) {
      workSlot.pauseDuration +=
          workSlot.stopTime.difference(workSlot.pauseTime).inMilliseconds;
    }

    workSlot.timerStatus = Status.stopped.value;
    SlotRepository.updateWorkHourSlot(workSlot);
  }

  void pause() {
    workSlot.pauseTime = DateTime.now();
    workSlot.timerStatus = Status.paused.value;
    SlotRepository.updateWorkHourSlot(workSlot);
  }

  Duration getWorkDuration() {
    if (statusFromString(workSlot.timerStatus) == Status.running) {
      return DateTime.now().difference(workSlot.startTime) -
          Duration(milliseconds: workSlot.pauseDuration);
    }

    return workSlot.stopTime.difference(workSlot.startTime) -
        Duration(milliseconds: workSlot.pauseDuration);
  }
}
