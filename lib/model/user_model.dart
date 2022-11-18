import 'dart:convert';

import 'package:tudo_em_casa_receitas/model/recipe_user_model.dart';
import 'package:tudo_em_casa_receitas/model/user_info_model.dart';

class UserModel {
  String id;
  String idFirestore;
  String name;
  String image;
  String description;
  String wallpaperImage;
  String deviceToken;
  List<RecipeUser> recipeList;

  List<String> recipeLikes;
  int followers;
  int following;
  List<UserInfo> followersList;
  List<UserInfo> followingList;
  UserModel(
      {required this.id,
      required this.idFirestore,
      required this.name,
      required this.image,
      required this.wallpaperImage,
      required this.followers,
      required this.followersList,
      required this.description,
      required this.recipeList,
      required this.recipeLikes,
      required this.following,
      required this.deviceToken,
      required this.followingList});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      idFirestore: json['idFirestore'] ?? "",
      name: json["name"],
      image: json["image"],
      wallpaperImage: json['wallpaper'],
      deviceToken: json['deviceToken'] ?? "",
      recipeList: json['recipes']
          .map<RecipeUser>((item) => RecipeUser.fromJson(item))
          .toList(),
      followers: json['followers'],
      following: json['following'],
      followersList: List<UserInfo>.from(
          json['followersList'].map((e) => UserInfo.fromJson(e)).toList() ??
              []),
      followingList: List<UserInfo>.from(
          json['followingList'].map((e) => UserInfo.fromJson(e)).toList() ??
              []),
      description: json['description'] ?? "",
      recipeLikes: json['recipeLikes'] == null
          ? []
          : List<String>.from(json['recipeLikes']),
    );
  }
  static Map<String, dynamic> toMap(UserModel user) => {
        "id": user.id,
        "idFirestore": user.idFirestore,
        "name": user.name,
        "image": user.image,
        'recipes': user.recipeList.map((e) => e.toJson()).toList(),
        "wallpaper": user.wallpaperImage,
        "deviceToken": user.deviceToken,
        "followers": user.followers,
        "following": user.following,
        "followersList": user.followersList.map((e) => e.toJson()).toList(),
        "followingList": user.followingList.map((e) => e.toJson()).toList(),
        "description": user.description,
        "recipeLikes": user.recipeLikes,
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
  static UserModel empty() => UserModel(
        id: "",
        idFirestore: "",
        image: "",
        name: "",
        deviceToken: "",
        wallpaperImage: "",
        recipeList: [],
        followers: -1,
        following: -1,
        followersList: [],
        followingList: [],
        description: "",
        recipeLikes: [],
      );
}
