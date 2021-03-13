class WorkHourSlotModel {
  final String id;
  final String userId;
  final String optionId;
  final DateTime startTime;
  final DateTime stopTime;
  final int breakDuration;
  final int workDuration;
  final String timerStatus;

  WorkHourSlotModel({
    this.id,
    this.userId,
    this.optionId,
    this.startTime,
    this.stopTime,
    this.breakDuration,
    this.workDuration,
    this.timerStatus,
  });

  factory WorkHourSlotModel.fromJson(String id, Map<String, dynamic> data) =>
      WorkHourSlotModel(
        id: id,
        userId: data['userId'] as String,
        optionId: data['optionId'] as String,
        startTime: data['startTime'] as DateTime,
        stopTime: data['stopTime'] as DateTime,
        breakDuration: data['breakDuration'] as int,
        workDuration: data['workDuration'] as int,
        timerStatus: data['timerStatus'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'optionId': optionId,
        'startTime': startTime,
        'stopTime': stopTime,
        'breakDuration': breakDuration,
        'workDuration': workDuration,
        'timerStatus': timerStatus,
      };
}
