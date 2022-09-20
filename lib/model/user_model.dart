import 'dart:convert';

class UserModel {
  String id;
  String name;
  String image;
  String wallpaperImage;
  List<String> recipeList;
  int followers;
  int following;
  UserModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.wallpaperImage,
      required this.followers,
      required this.recipeList,
      required this.following});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        wallpaperImage: json['wallpaper'],
        recipeList: List<String>.from(json['recipes']),
        followers: json['followers'],
        following: json['following']);
  }
  static Map<String, dynamic> toMap(UserModel user) => {
        "id": user.id,
        "name": user.name,
        "image": user.image,
        'recipes': user.recipeList,
        "wallpaper": user.wallpaperImage,
        "followers": user.followers,
        "following": user.following,
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
}
