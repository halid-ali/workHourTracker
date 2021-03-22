import 'package:cloud_firestore/cloud_firestore.dart';

class SlotModel {
  String id;
  String userId;
  String optionId;
  DateTime startTime;
  DateTime pauseTime;
  DateTime stopTime;
  int pauseDuration;
  String timerStatus;

  SlotModel({
    this.id,
    this.userId,
    this.optionId,
    this.startTime,
    this.pauseTime,
    this.stopTime,
    this.pauseDuration = 0,
    this.timerStatus = 'none',
  });

  factory SlotModel.fromJson(String id, Map<String, dynamic> data) {
    Timestamp start = data['startTime'];
    Timestamp pause = data['pauseTime'];
    Timestamp stop = data['stopTime'];

    var startDatetime = start != null
        ? DateTime.fromMillisecondsSinceEpoch(start.millisecondsSinceEpoch)
        : null;
    var pauseDatetime = pause != null
        ? DateTime.fromMillisecondsSinceEpoch(pause.millisecondsSinceEpoch)
        : null;
    var stopDatetime = stop != null
        ? DateTime.fromMillisecondsSinceEpoch(stop.millisecondsSinceEpoch)
        : null;

    return SlotModel(
      id: id,
      userId: data['userId'] as String,
      optionId: data['optionId'] as String,
      startTime: startDatetime,
      pauseTime: pauseDatetime,
      stopTime: stopDatetime,
      pauseDuration: data['pauseDuration'] as int,
      timerStatus: data['timerStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'optionId': optionId,
        'startTime': startTime,
        'pauseTime': pauseTime,
        'stopTime': stopTime,
        'pauseDuration': pauseDuration,
        'timerStatus': timerStatus,
      };
}
