class SettingsModel {
  final String id;
  final String userId;
  final String language;

  SettingsModel({
    this.id,
    this.userId,
    this.language,
  });

  factory SettingsModel.fromJson(String id, Map<String, dynamic> data) =>
      SettingsModel(
        id: id,
        userId: data['userId'] as String,
        language: data['language'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'language': language,
      };
}
