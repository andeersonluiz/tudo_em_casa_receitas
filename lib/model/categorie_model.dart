class Categorie {
  final String name;
  bool isSelected;
  int order;
  bool isRevision;
  String userId;
  bool hasError;
  Categorie({
    required this.name,
    this.isSelected = false,
    this.order = 0,
    this.isRevision = false,
    this.hasError = false,
    this.userId = "",
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      name: json['name'],
      userId: json['userId'] ??= "",
    );
  }

  toJson() => {"name": name, "userId": userId};

  @override
  String toString() {
    return "$name $isRevision $hasError";
  }

  static Categorie emptyClass() => Categorie(name: "");
}
