import 'dart:convert';

import 'package:tudo_em_casa_receitas/model/infos_model.dart';

class Recipe {
  final String id;
  final String title;
  final Info infos;
  final List<String> ingredients;
  final List<String> preparation;
  final List<int> sizes;
  final List<String> values;
  final List<String> categories;
  final String url;
  final String imageUrl;
  final int views;
  bool isFavorite;
  String missingIngredient;
  Recipe(
      {required this.id,
      required this.title,
      required this.infos,
      required this.ingredients,
      required this.preparation,
      required this.url,
      required this.imageUrl,
      required this.sizes,
      required this.values,
      required this.categories,
      required this.views,
      required this.missingIngredient,
      this.isFavorite = false});

  factory Recipe.fromJson(Map<String, dynamic> json, id,
          {String missingIngredient = "", bool isFavorite = false}) =>
      Recipe(
          id: id,
          title: json['title'],
          infos: Info.fromJson(json['infos']),
          ingredients: json['ingredients']
              .map<String>((item) => (item).toString())
              .toList(),
          preparation: json['preparation']
              .map<String>((item) => (item).toString())
              .toList(),
          categories: json['categories']
              .map<String>((item) => (item).toString())
              .toList(),
          sizes: List<int>.from(json['sizes']),
          url: json['url'],
          values:
              json['values'].map<String>((item) => (item).toString()).toList(),
          views: json['views'],
          missingIngredient: missingIngredient,
          imageUrl: json['imageUrl'] ?? "",
          isFavorite: isFavorite);

  toJson() => {
        "id": id,
        "title": title,
        "infos": infos.toJson(),
        "ingredients": ingredients,
        "preparation": preparation,
        "categories": categories,
        "sizes": sizes,
        "url": url,
        "values": values,
        "views": views,
        "imageUrl": imageUrl,
        "isFavorite": isFavorite
      };
  static Map<String, dynamic> toMap(Recipe recipe) => {
        "id": recipe.id,
        "title": recipe.title,
        "infos": recipe.infos.toJson(),
        "ingredients": recipe.ingredients,
        "preparation": recipe.preparation,
        "categories": recipe.categories,
        "sizes": recipe.sizes,
        "url": recipe.url,
        "values": recipe.values,
        "views": recipe.views,
        "imageUrl": recipe.imageUrl,
        "isFavorite": recipe.isFavorite
      };

  static String encode(List<Recipe> recipes) => json.encode(
        recipes
            .map<Map<String, dynamic>>((recipe) => Recipe.toMap(recipe))
            .toList(),
      );

  static List<Recipe> decode(String recipes) =>
      (json.decode(recipes) as List<dynamic>).map<Recipe>((recipe) {
        return Recipe.fromJson(recipe, recipe["id"]);
      }).toList();
}
