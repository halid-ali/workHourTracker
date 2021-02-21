class WorkSlots {
  final int id;
  final int optionId;
  final DateTime startTime;
  final DateTime stopTime;
  final int breakDuration; // seconds
  final int workDuration; // seconds

  WorkSlots({
    this.id,
    this.optionId,
    this.startTime,
    this.stopTime,
    this.breakDuration,
    this.workDuration,
  });

  factory WorkSlots.fromJson(Map<String, dynamic> data) => WorkSlots(
        id: data['id'],
        optionId: data['optionId'],
        startTime: data['startTime'],
        stopTime: data['stopTime'],
        breakDuration: data['breakDuration'],
        workDuration: data['workDuration'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'optionId': optionId,
        'startTime': startTime,
        'stopTime': stopTime,
        'breakDuration': breakDuration,
        'workDuration': workDuration,
      };
}
