class OptionModel {
  final String id;
  final String name;
  final String description;

  OptionModel({
    this.id,
    this.name,
    this.description,
  });

  factory OptionModel.fromJson(String id, Map<String, dynamic> data) =>
      OptionModel(
        id: id,
        name: data['name'] as String,
        description: data['description'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'description': description,
      };

  bool operator ==(dynamic other) =>
      other != null && other is OptionModel && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
