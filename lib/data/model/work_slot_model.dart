class WorkSlot {
  final int id;
  final int userId;
  final int optionId;
  final DateTime startTime;
  final DateTime stopTime;
  final int breakDuration; // seconds
  final int workDuration; // seconds

  WorkSlot({
    this.id,
    this.userId,
    this.optionId,
    this.startTime,
    this.stopTime,
    this.breakDuration,
    this.workDuration,
  });

  factory WorkSlot.fromJson(Map<String, dynamic> data) => WorkSlot(
        id: data['id'],
        userId: data['userId'],
        optionId: data['optionId'],
        startTime: DateTime.fromMillisecondsSinceEpoch(
          data['startTime'] as int,
        ),
        stopTime: DateTime.fromMillisecondsSinceEpoch(
          data['stopTime'] as int,
        ),
        breakDuration: data['breakDuration'],
        workDuration: data['workDuration'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'optionId': optionId,
        'startTime': startTime.millisecondsSinceEpoch,
        'stopTime': stopTime.millisecondsSinceEpoch,
        'breakDuration': breakDuration,
        'workDuration': workDuration,
      };
}
