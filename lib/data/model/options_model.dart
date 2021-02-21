class Options {
  final int id;
  final String name;

  Options({
    this.id,
    this.name,
  });

  factory Options.fromJson(Map<String, dynamic> data) => Options(
        id: data['id'],
        name: data['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
