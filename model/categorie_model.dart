class Categorie {
  final String name;
  bool isSelected;
  int order;
  bool isRevision;
  Categorie({
    required this.name,
    this.isSelected = false,
    this.order = 0,
    this.isRevision = false,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) =>
      Categorie(name: json['name']);

  toJson() => {
        "name": name,
      };
}
