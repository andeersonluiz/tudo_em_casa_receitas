import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/categorie_model.dart';
import 'package:tudo_em_casa_receitas/model/infos_model.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';
import 'package:tudo_em_casa_receitas/model/preparation_item.dart';
import 'package:twitter_login/entity/user.dart';

import 'user_info_model.dart';

enum StatusRevisionRecipe { Checked, Revision, Error }

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
  int views;
  bool isFavorite;
  bool isLiked;
  String missingIngredient;
  bool isRevision;
  UserInfo? userInfo;
  List<Ingredient> ingredientsRevision;
  List<Measure> measuresRevision;
  List<Categorie> categoriesRevision;
  List<Ingredient> ingredientsRevisionError;
  List<Measure> measuresRevisionError;
  List<Categorie> categoriesRevisionError;
  List<Ingredient> ingredientsRevisionSuccessfully;
  List<Measure> measuresRevisionSuccessfully;
  List<Categorie> categoriesRevisionSuccessfully;
  StatusRevisionRecipe statusRecipe;
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
      required this.ingredientsRevision,
      required this.measuresRevision,
      required this.categoriesRevision,
      required this.ingredientsRevisionError,
      required this.measuresRevisionError,
      required this.categoriesRevisionError,
      required this.ingredientsRevisionSuccessfully,
      required this.measuresRevisionSuccessfully,
      required this.categoriesRevisionSuccessfully,
      this.isRevision = false,
      this.isFavorite = false,
      this.statusRecipe = StatusRevisionRecipe.Checked,
      this.isLiked = false});

  factory Recipe.fromJson(Map<String, dynamic> json, id,
      {String missingIngredient = "",
      bool isFavorite = false,
      bool isLiked = false,
      bool verifyStatusRecipe = false}) {
    print(json['ingredients']);
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
                  print(item);
                  print("aaaa");
                  if (item.length == 2 || item.length == 3) {
                    print("Len =2 |3");
                    return IngredientItem.fromJsonList(
                        (Map<String, dynamic>.from(item)));
                  } else {
                    print("Len !=2 |3");
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
      categories:
          json['categories'].map<String>((item) => (item).toString()).toList(),
      sizes: List<int>.from(json['sizes']),
      url: json['url'],
      createdOn: json['createdOn'] ?? Timestamp.now(),
      updatedOn: json['updatedOn'] ?? Timestamp.now(),
      favorites: json['favorites'],
      likes: json['likes'] ?? 0,
      values: json['values'].map<String>((item) => (item).toString()).toList(),
      views: json['views'],
      userInfo: json['userInfo'] == null
          ? UserInfo(idUser: "", name: "", imageUrl: "", followers: -1)
          : UserInfo.fromJson(json['userInfo']),
      missingIngredient: missingIngredient,
      imageUrl: json['imageUrl'] ?? "",
      isFavorite: isFavorite,
      isLiked: isLiked,
      categoriesRevision: List<Categorie>.from(
          json['categoriesRevision'] == null
              ? []
              : json['categoriesRevision']
                  .map<Categorie>((item) => Categorie.fromJson(item))
                  .toList()),
      ingredientsRevision: List<Ingredient>.from(
              json['ingredientsRevision'] == null
                  ? []
                  : json['ingredientsRevision'].map<Ingredient>(
                      (item) => Ingredient.fromJson(item, item["id"])))
          .toList(),
      measuresRevision: List<Measure>.from(json['measuresRevision'] == null
          ? []
          : json['measuresRevision']
              .map<Measure>((item) => Measure.fromJson(item))
              .toList()),
      measuresRevisionError: List<Measure>.from(
          json['measuresRevisionError'] == null
              ? []
              : json['measuresRevisionError']
                  .map<Measure>((item) => Measure.fromJson(item))
                  .toList()),
      categoriesRevisionError: List<Categorie>.from(
          json['categoriesRevisionError'] == null
              ? []
              : json['categoriesRevisionError']
                  .map<Categorie>((item) => Categorie.fromJson(item))
                  .toList()),
      ingredientsRevisionError: List<Ingredient>.from(
              json['ingredientsRevisionError'] == null
                  ? []
                  : json['ingredientsRevisionError'].map<Ingredient>(
                      (item) => Ingredient.fromJson(item, item["id"])))
          .toList(),
      categoriesRevisionSuccessfully: List<Categorie>.from(
          json['categoriesRevisionSuccessfully'] == null
              ? []
              : json['categoriesRevisionSuccessfully']
                  .map<Categorie>((item) => Categorie.fromJson(item))
                  .toList()),
      ingredientsRevisionSuccessfully: List<Ingredient>.from(
              json['ingredientsRevisionSuccessfully'] == null
                  ? []
                  : json['ingredientsRevisionSuccessfully'].map<Ingredient>(
                      (item) => Ingredient.fromJson(item, item["id"])))
          .toList(),
      measuresRevisionSuccessfully: List<Measure>.from(
          json['measuresRevisionSuccessfully'] == null
              ? []
              : json['measuresRevisionSuccessfully']
                  .map<Measure>((item) => Measure.fromJson(item))
                  .toList()),
      statusRecipe: json["statusRecipe"] == null
          ? StatusRevisionRecipe.Checked
          : StatusRevisionRecipe.values[json["statusRecipe"]],
    );
    print("chamei");
    if (verifyStatusRecipe) {
      if (x.ingredientsRevision.isNotEmpty ||
          x.categoriesRevision.isNotEmpty ||
          x.measuresRevision.isNotEmpty) {
        x.statusRecipe = StatusRevisionRecipe.Revision;
        print("chamei st ${x.statusRecipe}");
      } else if ((x.ingredientsRevision.isEmpty &&
              x.categoriesRevision.isEmpty &&
              x.measuresRevision.isEmpty) &&
          (x.categoriesRevisionError.isNotEmpty ||
              x.categoriesRevisionError.isNotEmpty ||
              x.measuresRevisionError.isNotEmpty)) {
        x.statusRecipe = StatusRevisionRecipe.Error;
        print("chamei st ${x.statusRecipe}");
      }
    }

    return x;
  }
  toJson() {
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
      "categoriesRevision": categoriesRevision.map((e) => e.toJson()).toList(),
      "ingredientsRevision":
          ingredientsRevision.map((e) => e.toJson()).toList(),
      "measuresRevision": measuresRevision.map((e) => e.toJson()).toList(),
      "categoriesRevisionError":
          categoriesRevisionError.map((e) => e.toJson()).toList(),
      "ingredientsRevisionError":
          ingredientsRevisionError.map((e) => e.toJson()).toList(),
      "measuresRevisionError":
          measuresRevisionError.map((e) => e.toJson()).toList(),
      "categoriesRevisionSuccessfully":
          categoriesRevisionSuccessfully.map((e) => e.toJson()).toList(),
      "ingredientsRevisionSuccessfully":
          ingredientsRevisionSuccessfully.map((e) => e.toJson()).toList(),
      "measuresRevisionSuccessfully":
          measuresRevisionSuccessfully.map((e) => e.toJson()).toList(),
      "statusRecipe": statusRecipe.index,
    };
  }

  static Map<String, dynamic> toMap(Recipe recipe) => {
        "id": recipe.id,
        "title": recipe.title,
        "favorites": recipe.favorites,
        "likes": recipe.likes,
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
        "imageUrl": recipe.imageUrl,
        "isFavorite": recipe.isFavorite,
        "isLiked": recipe.isLiked
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
      isFavorite: rec.isFavorite,
      isLiked: rec.isLiked,
      createdOn: rec.createdOn,
      updatedOn: rec.updatedOn,
      categoriesRevision: rec.categoriesRevision,
      ingredientsRevision: rec.ingredientsRevision,
      measuresRevision: rec.measuresRevision,
      measuresRevisionError: rec.measuresRevisionError,
      categoriesRevisionError: rec.categoriesRevisionError,
      ingredientsRevisionError: rec.ingredientsRevisionError,
      categoriesRevisionSuccessfully: rec.categoriesRevisionSuccessfully,
      ingredientsRevisionSuccessfully: rec.ingredientsRevisionSuccessfully,
      measuresRevisionSuccessfully: rec.measuresRevisionSuccessfully,
      statusRecipe: rec.statusRecipe,
      isRevision: rec.isRevision,
    );
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
        isFavorite: false,
        isLiked: false,
        categories: [],
        userInfo: UserInfo(idUser: "", name: "", imageUrl: "", followers: -1),
        createdOn: Timestamp.now(),
        updatedOn: Timestamp.now(),
        categoriesRevision: [],
        ingredientsRevision: [],
        measuresRevision: [],
        categoriesRevisionError: [],
        categoriesRevisionSuccessfully: [],
        ingredientsRevisionError: [],
        ingredientsRevisionSuccessfully: [],
        measuresRevisionError: [],
        measuresRevisionSuccessfully: []);
  }
}
