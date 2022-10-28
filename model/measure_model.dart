class Measure {
  final String name;
  final String plural;
  int order;
  bool isRevision;
  Measure(
      {required this.name,
      required this.plural,
      this.isRevision = false,
      this.order = 0});

  factory Measure.fromJson(Map<String, dynamic> json) =>
      Measure(name: json['name'], plural: json['plural']);

  toJson() => {'name': name, 'plural': plural};
}
