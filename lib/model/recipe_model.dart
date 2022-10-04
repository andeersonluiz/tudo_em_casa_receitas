import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tudo_em_casa_receitas/model/infos_model.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/model/preparation_item.dart';
import 'package:twitter_login/entity/user.dart';

import 'user_info_model.dart';

class Recipe {
  String id;
  int favorites;
  int likes;
  Timestamp createdOn;
  Timestamp updatedOn;
  final String title;
  final Info infos;
  final List<dynamic> ingredients;
  //final List<IngredientItem> ingredientsNew;
  final List<dynamic> preparation;
  final List<int> sizes;
  final List<dynamic> values;
  List<String> categories;
  final String url;
  String imageUrl;
  final int views;
  bool isFavorite;
  String missingIngredient;
  bool isRevision;
  UserInfo? userInfo;
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
      required this.views,
      required this.missingIngredient,
      this.categories = const [],
      required this.favorites,
      required this.likes,
      required this.createdOn,
      required this.updatedOn,
      this.userInfo,
      this.isRevision = false,
      this.isFavorite = false});

  factory Recipe.fromJson(Map<String, dynamic> json, id,
      {String missingIngredient = "", bool isFavorite = false}) {
    print(json['categories']);
    var x = Recipe(
        id: id,
        title: json['title'],
        infos: Info.fromJson(json['infos']),
        ingredients: json['ingredients'].isEmpty
            ? []
            : json['ingredients'][0] is String
                ? json['ingredients']
                    .map<String>((item) => (item).toString())
                    .toList()
                : json['ingredients'].map((item) {
                    if (item.length == 2 || item.length == 3) {
                      return IngredientItem.fromJsonList(
                          (Map<String, dynamic>.from(item)));
                    } else {
                      return IngredientItem.fromJson(item);
                    }
                  }).toList(),
        preparation: json['preparation'].isEmpty
            ? []
            : json['preparation'][0] is String
                ? json['preparation']
                    .map<String>((item) => (item).toString())
                    .toList()
                : json['preparation']
                    .map((item) => PreparationItem.fromJson(item))
                    .toList(),
        categories: json['categories']
            .map<String>((item) => (item).toString())
            .toList(),
        sizes: List<int>.from(json['sizes']),
        url: json['url'],
        createdOn: json['createdOn'] ?? Timestamp.now(),
        updatedOn: json['updatedOn'] ?? Timestamp.now(),
        favorites: json['favorites'],
        likes: json['likes'] ?? 0,
        values:
            json['values'].map<String>((item) => (item).toString()).toList(),
        views: json['views'],
        userInfo: json['userInfo'] == null
            ? UserInfo(idUser: "", name: "", imageUrl: "", followers: -1)
            : UserInfo.fromJson(json['userInfo']),
        missingIngredient: missingIngredient,
        imageUrl: json['imageUrl'] ?? "",
        isFavorite: isFavorite);
    return x;
  }
  toJson() {
    print(userInfo);
    return {
      "id": id,
      "title": title,
      "favorites": favorites,
      "likes": likes,
      "infos": infos.toJson(),
      "ingredients": ingredients is List<String>
          ? ingredients
          : ingredients.map((e) {
              if (e is IngredientItem) {
                return e.toJson();
              } else {
                return IngredientItem.toJsonList(e);
              }
            }).toList(),
      "preparation": preparation is List<String>
          ? preparation
          : preparation.map((e) => e.toJson()).toList(),
      "sizes": sizes,
      "url": url,
      "values": values,
      "views": views,
      "createdOn": createdOn,
      "userInfo": userInfo!.toJson(),
      "updatedOn": updatedOn,
      "categories": categories,
      "imageUrl": imageUrl,
    };
  }

  static Map<String, dynamic> toMap(Recipe recipe) => {
        "id": recipe.id,
        "title": recipe.title,
        "favorites": recipe.favorites, "likes": recipe.likes,
        "infos": recipe.infos.toJson(),
        "ingredients": recipe.ingredients is List<String>
            ? recipe.ingredients
            : recipe.ingredients.map((e) => e.toJson()).toList(),
        "preparation": recipe.preparation is List<String>
            ? recipe.preparation
            : recipe.preparation.map((e) => e.toJson()).toList(),
        "categories": recipe.categories,
        "sizes": recipe.sizes,
        "url": recipe.url,
        "values": recipe.values,
        "views": recipe.views,
        "idUser": recipe.userInfo!.toJson(),
        //"createdOn": recipe.createdOn,
        // "updatedOn": recipe.updatedOn,
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

  static Recipe copyWith(Recipe rec) {
    return Recipe(
        id: rec.id,
        title: rec.title,
        infos: rec.infos,
        ingredients: rec.ingredients,
        preparation: rec.preparation,
        url: rec.url,
        imageUrl: rec.imageUrl,
        sizes: rec.sizes,
        values: rec.values,
        views: rec.views,
        missingIngredient: rec.missingIngredient,
        favorites: rec.favorites,
        likes: rec.likes,
        userInfo: rec.userInfo,
        categories: rec.categories,
        createdOn: rec.createdOn,
        updatedOn: rec.updatedOn);
  }

  static Recipe empty() {
    return Recipe(
      id: "",
      title: "",
      infos: Info(preparationTime: -1, yieldRecipe: -1),
      ingredients: [],
      preparation: [],
      url: "",
      imageUrl: "",
      sizes: [],
      values: [],
      views: -1,
      missingIngredient: "",
      favorites: -1,
      likes: -1,
      categories: [],
      userInfo: UserInfo(idUser: "", name: "", imageUrl: "", followers: -1),
      createdOn: Timestamp.now(),
      updatedOn: Timestamp.now(),
    );
  }
}
