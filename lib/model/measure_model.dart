class Measure {
  final String name;
  final String plural;
  Measure({required this.name, required this.plural});

  factory Measure.fromJson(Map<String, dynamic> json) =>
      Measure(name: json['name'], plural: json['plural']);

  toJson() => {'name': name, 'plural': plural};
}
