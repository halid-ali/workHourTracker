class OptionModel {
  final String id;
  final String userId;
  final String name;
  final String description;

  OptionModel({
    this.id,
    this.userId,
    this.name,
    this.description,
  });

  factory OptionModel.fromJson(String id, Map<String, dynamic> data) =>
      OptionModel(
        id: id,
        userId: data['userId'],
        name: data['name'] as String,
        description: data['description'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'name': name,
        'description': description,
      };

  bool operator ==(dynamic other) =>
      other != null && other is OptionModel && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
