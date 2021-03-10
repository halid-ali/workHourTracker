class WorkHourOption {
  final String id;
  final String name;
  final String description;

  WorkHourOption({
    this.id,
    this.name,
    this.description,
  });

  factory WorkHourOption.fromJson(String id, Map<String, dynamic> data) =>
      WorkHourOption(
        id: id,
        name: data['name'] as String,
        description: data['description'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'description': description,
      };
}
