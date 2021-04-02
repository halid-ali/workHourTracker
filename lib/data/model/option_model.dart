class OptionModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final bool isActive;

  OptionModel({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.isActive,
  });

  factory OptionModel.fromJson(String id, Map<String, dynamic> data) =>
      OptionModel(
        id: id,
        userId: data['userId'],
        name: data['name'] as String,
        description: data['description'] as String,
        isActive: data['isActive'] as int == 1,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'name': name,
        'description': description,
        'isActive': isActive ? 1 : 0,
      };

  bool operator ==(dynamic other) =>
      other != null && other is OptionModel && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
