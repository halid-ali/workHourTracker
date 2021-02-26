class Option {
  final int id;
  final String name;

  Option({
    this.id,
    this.name,
  });

  factory Option.fromJson(Map<String, dynamic> data) => Option(
        id: data['id'],
        name: data['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
