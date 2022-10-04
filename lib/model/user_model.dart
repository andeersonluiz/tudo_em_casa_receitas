import 'dart:convert';

import 'package:tudo_em_casa_receitas/model/categorie_model.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';
import 'package:tudo_em_casa_receitas/model/recipe_user_model.dart';

class UserModel {
  String id;
  String name;
  String image;
  String wallpaperImage;
  List<RecipeUser> recipeList;
  List<Ingredient> ingredientsRevision;
  List<Measure> measuresRevision;
  List<Categorie> categoriesRevision;
  List<String> recipeLikes;
  int followers;
  int following;
  UserModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.wallpaperImage,
      required this.followers,
      required this.ingredientsRevision,
      required this.measuresRevision,
      required this.categoriesRevision,
      required this.recipeList,
      required this.recipeLikes,
      required this.following});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      wallpaperImage: json['wallpaper'],
      recipeList: json['recipes']
          .map<RecipeUser>((item) => RecipeUser.fromJson(item))
          .toList(),
      followers: json['followers'],
      following: json['following'],
      recipeLikes: json['recipeLikes'] == null
          ? []
          : List<String>.from(json['recipeLikes']),
      categoriesRevision: json['categoriesRevision']
          .map<Categorie>((item) => Categorie.fromJson(item))
          .toList(),
      ingredientsRevision: json['ingredientsRevision']
          .map<Ingredient>((item) => Ingredient.fromJson(item, item["id"]))
          .toList(),
      measuresRevision: json['measuresRevision']
          .map<Measure>((item) => Measure.fromJson(item))
          .toList(),
    );
  }
  static Map<String, dynamic> toMap(UserModel user) => {
        "id": user.id,
        "name": user.name,
        "image": user.image,
        'recipes': user.recipeList.map((e) => e.toJson()).toList(),
        "wallpaper": user.wallpaperImage,
        "followers": user.followers,
        "following": user.following,
        "recipeLikes": user.recipeLikes,
        "categoriesRevision":
            user.categoriesRevision.map((e) => e.toJson()).toList(),
        "ingredientsRevision":
            user.ingredientsRevision.map((e) => e.toJson()).toList(),
        "measuresRevision":
            user.measuresRevision.map((e) => e.toJson()).toList(),
      };

  static String encode(List<UserModel> users) => json.encode(
        users
            .map<Map<String, dynamic>>((user) => UserModel.toMap(user))
            .toList(),
      );
  static List<UserModel> decode(String users) =>
      (json.decode(users) as List<dynamic>).map<UserModel>((user) {
        return UserModel.fromJson(user);
      }).toList();
  static empty() => UserModel(
      id: "",
      image: "",
      name: "",
      wallpaperImage: "",
      recipeList: [],
      followers: -1,
      following: -1,
      recipeLikes: [],
      categoriesRevision: [],
      ingredientsRevision: [],
      measuresRevision: []);
}
