class RecipeUser {
  String id;
  bool isRevision;

  RecipeUser({required this.id, required this.isRevision});

  factory RecipeUser.fromJson(Map<String, dynamic> json) {
    return RecipeUser(id: json['id'], isRevision: json['isRevision']);
  }

  toJson() => {
        "id": id,
        "isRevision": isRevision,
      };
}
