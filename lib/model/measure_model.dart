class Measure {
  final String name;
  final String plural;
  int order;
  bool isRevision;
  bool hasError;
  String userId;
  Measure({
    required this.name,
    required this.plural,
    this.isRevision = false,
    this.hasError = false,
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
        hasError: measure.hasError,
        userId: measure.userId);
  }

  @override
  String toString() {
    return "'name': $name, 'plural': $plural, 'userId': $userId , 'isRevision' :$isRevision 'hasError' $hasError";
  }

  static Measure emptyClass() {
    return Measure(name: "", plural: "");
  }
}
