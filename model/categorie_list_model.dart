import 'dart:convert';

class CategorieList {
  final String name;
  int count;
  CategorieList({
    required this.name,
    required this.count,
  });

  factory CategorieList.fromJson(Map<String, dynamic> json, {int count = 0}) =>
      CategorieList(name: json['name'], count: count);

  toJson() => {"name": name, "count": count};

  static String encode(List<CategorieList> categories) => json.encode(
        categories
            .map<Map<String, dynamic>>((categorie) => categorie.toJson())
            .toList(),
      );
  static List<CategorieList> decode(String categories) =>
      (json.decode(categories) as List<dynamic>)
          .map<CategorieList>((categorie) {
        return CategorieList.fromJson(categorie, count: categorie["count"]);
      }).toList();

  @override
  String toString() {
    return "$name : $count";
  }
}
