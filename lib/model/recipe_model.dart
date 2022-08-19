import 'package:tudo_em_casa_receitas/model/infos_model.dart';

class Recipe {
  final int id;
  final String title;
  final Info infos;
  final List<String> ingredients;
  final List<String> preparation;
  final String url;
  final String imageUrl;
  List<String> missingIngredients;
  Recipe(
      {required this.id,
      required this.title,
      required this.infos,
      required this.ingredients,
      required this.preparation,
      required this.url,
      required this.imageUrl,
      this.missingIngredients = const []});

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
      id: int.parse(json["id"] ?? "-1"),
      title: json['title'],
      infos: Info.fromJson(json['infos']),
      ingredients:
          json['ingredients'].map<String>((item) => (item).toString()).toList(),
      preparation:
          json['preparation'].map<String>((item) => (item).toString()).toList(),
      url: json['url'],
      imageUrl: json['imageUrl'] ?? "");

  toJson() => {
        "id": id,
        "title": title,
        "infos": infos.toJson(),
        "ingredients": ingredients,
        "preparation": preparation,
        "url": url,
        "imageUrl": imageUrl
      };
}
