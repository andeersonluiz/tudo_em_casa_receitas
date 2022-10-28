class Measure {
  final String name;
  final String plural;
  int order;
  bool isRevision;
  String userId;
  Measure({
    required this.name,
    required this.plural,
    this.isRevision = false,
    this.order = 0,
    this.userId = "",
  });

  factory Measure.fromJson(Map<String, dynamic> json) => Measure(
      name: json['name'],
      plural: json['plural'],
      userId: json['userId'] ??= "");

  toJson() => {
        'name': name,
        'plural': plural,
        "userId": userId,
      };

  static Measure copyWith(Measure measure) {
    return Measure(
        name: measure.name,
        plural: measure.plural,
        order: measure.order,
        isRevision: measure.isRevision,
        userId: measure.userId);
  }

  @override
  String toString() {
    return "'name': $name, 'plural': $plural, 'userId': $userId , 'isRevision' :$isRevision";
  }
}
