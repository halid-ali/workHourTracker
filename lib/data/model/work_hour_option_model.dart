class WorkHourOptionModel {
  final String id;
  final String name;
  final String description;

  WorkHourOptionModel({
    this.id,
    this.name,
    this.description,
  });

  factory WorkHourOptionModel.fromJson(String id, Map<String, dynamic> data) =>
      WorkHourOptionModel(
        id: id,
        name: data['name'] as String,
        description: data['description'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'description': description,
      };
}
