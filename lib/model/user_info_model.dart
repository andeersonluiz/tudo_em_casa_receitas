class UserInfo {
  String idUser;
  String name;
  String imageUrl;
  int followers;

  UserInfo(
      {required this.idUser,
      required this.name,
      required this.imageUrl,
      required this.followers});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
      idUser: json['idUser'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      followers: json['followers']);

  toJson() => {
        "idUser": idUser,
        "name": name,
        "imageUrl": imageUrl,
        "followers": followers,
      };
}
