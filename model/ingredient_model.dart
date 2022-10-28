import 'dart:convert';

class Ingredient {
  final String id;
  final String name;
  final String plurals;
  final int recipesCount;
  Ingredient? synonyms;
  bool isRevision;
  bool isSelected;
  bool isPantry;
  bool isHome;
  int order;
  String userId;
  Ingredient(
      {required this.id,
      required this.name,
      required this.isSelected,
      required this.plurals,
      required this.recipesCount,
      required this.order,
      required this.isPantry,
      required this.synonyms,
      this.isRevision = false,
      this.userId = "",
      required this.isHome});

  factory Ingredient.fromJson(Map<String, dynamic> json, String id,
      {bool isPantry = false, bool isHome = false}) {
    return Ingredient(
        id: id,
        name: json['name'],
        isSelected: false,
        isPantry: isPantry,
        isHome: isHome,
        order: 0,
        userId: json['userId'] ??= "",
        synonyms: json['synonyms'].isNotEmpty
            ? Ingredient(
                id: "",
                name: json['synonyms']['name'],
                isSelected: false,
                plurals: json['synonyms']["plural"],
                recipesCount: -1,
                order: 0,
                isPantry: false,
                synonyms: null,
                isHome: false)
            : null,
        plurals: json["plural"],
        recipesCount: json["recipesCount"]);
  }

  toJson() => {
        "id": id,
        "name": name,
        "plural": plurals,
        "recipesCount": recipesCount,
        "userId": userId,
        "synonyms": synonyms == null
            ? {}
            : {
                "name": synonyms!.name,
                "plural": synonyms!.plurals,
              },
      };

  static Map<String, dynamic> toMap(Ingredient ingredient) => {
        "id": ingredient.id,
        "name": ingredient.name,
        "isPantry": ingredient.isPantry,
        "synonyms": ingredient.synonyms == null
            ? {}
            : {
                "name": ingredient.synonyms!.name,
                "plural": ingredient.synonyms!.plurals,
              },
        "isHome": ingredient.isHome,
        "plural": ingredient.plurals,
        "recipesCount": ingredient.recipesCount,
      };

  static String encode(List<Ingredient> ingredients) => json.encode(
        ingredients
            .map<Map<String, dynamic>>(
                (ingredient) => Ingredient.toMap(ingredient))
            .toList(),
      );
  static List<Ingredient> decode(String ingredients) =>
      (json.decode(ingredients) as List<dynamic>).map<Ingredient>((ingredient) {
        return Ingredient.fromJson(ingredient, ingredient["id"],
            isPantry: ingredient["isPantry"], isHome: ingredient["isHome"]);
      }).toList();

  static Ingredient emptyClass({bool isRevision = false, String name = ""}) =>
      Ingredient(
          id: "",
          name: name,
          isSelected: false,
          plurals: "",
          recipesCount: -1,
          order: -1,
          isPantry: false,
          synonyms: null,
          isRevision: isRevision,
          isHome: false);
}
