import 'dart:convert';

class Tag {
  String name;
  int count;

  Tag({required this.name, required this.count});

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(name: json["name"], count: json["count"]);

  static Map<String, dynamic> toMap(Tag tag) =>
      {"name": tag.name, "count": tag.count};

  static String encode(List<Tag> recipes) => json.encode(
        recipes
            .map<Map<String, dynamic>>((recipe) => Tag.toMap(recipe))
            .toList(),
      );
  static List<Tag> decode(String tags) =>
      (json.decode(tags) as List<dynamic>).map<Tag>((tag) {
        return Tag.fromJson(tag);
      }).toList();
}
