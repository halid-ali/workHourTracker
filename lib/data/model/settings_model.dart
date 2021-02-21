class Settings {
  final String locale;

  Settings({
    this.locale,
  });

  factory Settings.fromJson(Map<String, dynamic> data) => Settings(
        locale: data['locale'],
      );

  Map<String, dynamic> toJson() => {
        'locale': locale,
      };
}
