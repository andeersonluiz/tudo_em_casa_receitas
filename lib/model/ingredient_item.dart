import 'dart:math';

import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';

class IngredientItem {
  String id;
  final String name;

  final String format;
  final bool isOptional;
  final int qtd;
  final Measure measure;
  final bool isSubtopic;
  bool isSelected;
  bool isChecked;
  bool isIngredientRevision;
  bool isRevision;
  Ingredient? ingredientSelected;
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  IngredientItem(
      {this.id = "",
      required this.name,
      required this.format,
      required this.isOptional,
      required this.measure,
      this.isSelected = false,
      this.isChecked = false,
      required this.isSubtopic,
      this.isIngredientRevision = false,
      this.isRevision = false,
      required this.ingredientSelected,
      required this.qtd});

  factory IngredientItem.fromJson(
    Map<String, dynamic> json,
  ) {
    print("ab");
    return IngredientItem(
        name: json['name'],
        format: json['format'],
        isOptional: json['isOptional'],
        measure: Measure.fromJson(json['measure']),
        ingredientSelected: json['ingredientSelected'] == null
            ? null
            : Ingredient.fromJson(
                json['ingredientSelected'], json["ingredientSelected"]["id"]),
        isSubtopic: json['isSubtopic'],
        qtd: json['qtd'],
        isIngredientRevision: json['isIngredientRevision'] ?? false);
  }
  static fromJsonList(
    Map<String, dynamic> json,
  ) {
    List<IngredientItem> list = [];
    for (int i = 0; i < json.length; i++) {
      list.add(IngredientItem(
          name: json[i.toString()]['name'],
          format: json[i.toString()]['format'],
          isOptional: json[i.toString()]['isOptional'],
          measure: Measure.fromJson(json[i.toString()]['measure']),
          ingredientSelected: json[i.toString()]['ingredientSelected'] == null
              ? null
              : Ingredient.fromJson(json[i.toString()]['ingredientSelected'],
                  json[i.toString()]["ingredientSelected"]["id"]),
          isSubtopic: json[i.toString()]['isSubtopic'],
          qtd: json[i.toString()]['qtd'],
          isIngredientRevision:
              json[i.toString()]['isIngredientRevision'] ?? false));
    }
    return list;
  }

  setId(String id) {
    this.id = id;
  }

  toJson() => {
        "name": name,
        "format": format,
        "isOptional": isOptional,
        "measure": measure.toJson(),
        "ingredientSelected": ingredientSelected!.toJson(),
        "isSubtopic": isSubtopic,
        "qtd": qtd,
        "isIngredientRevision": isIngredientRevision
      };
  static toJsonList(List<dynamic> list) {
    var index = 0;
    Map map = {};
    for (var e in list) {
      map[index.toString()] = {
        "name": e.name,
        "format": e.format,
        "isOptional": e.isOptional,
        "measure": e.measure.toJson(),
        "ingredientSelected": e.ingredientSelected!.toJson(),
        "isSubtopic": e.isSubtopic,
        "qtd": e.qtd,
        "isIngredientRevision": e.isIngredientRevision
      };
      index += 1;
    }
    return map;
  }

  @override
  String toString() {
    if (qtd == -1 &&
        format == "" &&
        measure.name == "" &&
        measure.plural == "") {
      return name;
    }
    if (format == "") {
      return "$qtd ${qtd > 1 ? measure.plural : measure.name} de $name";
    }
    return "$qtd ${qtd > 1 ? measure.plural : measure.name} de $name $format";
  }
}
