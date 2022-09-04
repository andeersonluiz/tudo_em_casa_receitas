import 'dart:convert';

class Ingredient {
  final String id;
  final String name;
  final String plurals;
  final int recipesCount;
  bool isSelected;
  bool isPantry;
  bool isHome;
  int order;
  Ingredient(
      {required this.id,
      required this.name,
      required this.isSelected,
      required this.plurals,
      required this.recipesCount,
      required this.order,
      required this.isPantry,
      required this.isHome});

  factory Ingredient.fromJson(Map<String, dynamic> json, String id,
          {bool isPantry = false, bool isHome = false}) =>
      Ingredient(
          id: id,
          name: json['name'],
          isSelected: false,
          isPantry: isPantry,
          isHome: isHome,
          order: 0,
          plurals: json["plural"],
          recipesCount: json["count"]);

  toJson() => {"name": name, plurals: "plural", recipesCount: "count"};

  static Map<String, dynamic> toMap(Ingredient ingredient) => {
        "id": ingredient.id,
        "name": ingredient.name,
        "isPantry": ingredient.isPantry,
        "isHome": ingredient.isHome,
        "plural": ingredient.plurals,
        "count": ingredient.recipesCount
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
}
