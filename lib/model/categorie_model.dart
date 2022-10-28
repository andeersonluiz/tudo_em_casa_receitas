class Categorie {
  final String name;
  bool isSelected;
  int order;
  bool isRevision;
  String userId;
  Categorie({
    required this.name,
    this.isSelected = false,
    this.order = 0,
    this.isRevision = false,
    this.userId = "",
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    print("cattt $json");
    return Categorie(name: json['name'], userId: json['userId'] ??= "");
  }

  toJson() => {"name": name, "userId": userId};

  @override
  String toString() {
    // TODO: implement toString
    return "$name $isRevision";
  }
}
