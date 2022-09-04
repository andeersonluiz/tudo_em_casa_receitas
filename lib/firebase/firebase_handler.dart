import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';

import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class FirebaseBaseHelper {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  Function eq = const ListEquality().equals;
  /*getIngredients(int limit, {startAfter}) async {
    var results = db.collection("ingredients").orderBy("name").limit(limit);
    if (startAfter != null) {
      results = results.startAfterDocument(startAfter);
    }
    List<QueryDocumentSnapshot<Map<String, dynamic>>> data;
    try {
      data = (await results.get()).docs;
    } catch (e) {
      print(e);
      return ["", null];
    }
    List<Ingredient> myList = data
        .map<Ingredient>((item) => Ingredient.fromJson(item.data(), item.id))
        .toList();

    return [data.last, myList];
  }*/

  getIngredients() async {
    var results = db.collection("ingredients").orderBy("name");
    List<QueryDocumentSnapshot<Map<String, dynamic>>> data;
    try {
      data = (await results.get()).docs;
    } catch (e) {
      throw "error-load-ingredients";
    }

    List<Ingredient> myList = data
        .map<Ingredient>((item) => Ingredient.fromJson(item.data(), item.id))
        .toList();

    return myList;
  }

  getIngredientQuery() {
    return db.collection('ingredients').orderBy('name');
  }

  getRecipes() async {
    var results =
        await db.collection("recipes").orderBy("views").limit(100).get();
    var data = results.docs;
    List<Recipe> myList = data
        .map<Recipe>((item) => Recipe.fromJson(
              item.data(),
              item.id,
            ))
        .toList();
    return myList;
  }

  static getRecipesByTag({String tag = ""}) async {
    final db = FirebaseFirestore.instance;
    dynamic results;
    if (tag.isEmpty) {
      results = await db.collection("recipes").orderBy("views").limit(20).get();
    } else {
      results = await db
          .collection("recipes")
          .where("categories", arrayContains: tag.toUpperCase())
          .limit(20)
          .get();
    }

    var data = results.docs;
    List<Recipe> myList = data.map<Recipe>((item) {
      if (LocalVariables.idsListRecipes.contains(item.id)) {
        return Recipe.fromJson(
          item.data(),
          item.id,
          isFavorite: true,
        );
      }
      return Recipe.fromJson(
        item.data(),
        item.id,
      );
    }).toList();
    return myList;
  }

  getRecipesByIngredients(List<String> ingredients) async {
    var data = await db
        .collection("recipes")
        .where("values", arrayContainsAny: ingredients)
        .get();
    var listMatched = data.docs.where((element) {
      return listContainsAll(
        ingredients,
        List<String>.from(element["values"]),
      );
    });
    var listMatchedBy1 = data.docs.where((element) {
      var diff =
          element["values"].where((el) => !ingredients.contains(el)).toList();
      return diff.length == 1;
    });

    List<Recipe> matched = listMatched
        .map<Recipe>((item) =>
            Recipe.fromJson(item.data(), item.id, missingIngredient: ""))
        .toList();
    List<Recipe> matchedBy1 = listMatchedBy1.map<Recipe>((item) {
      String missingIngredient =
          item["values"].where((el) => !ingredients.contains(el)).toList()[0];
      return Recipe.fromJson(item.data(), item.id,
          missingIngredient: missingIngredient);
    }).toList();

    return matched + matchedBy1;
  }

  String capitalizeEachWord(String input) {
    final List<String> splitStr = removeDiacritics(input).split(' ');
    for (int i = 0; i < splitStr.length; i++) {
      splitStr[i] =
          '${splitStr[i][0].toUpperCase()}${splitStr[i].substring(1)}';
    }
    final output = splitStr.join(' ');
    return output;
  }

  String removeDiacritics(String str) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  dynamic getIng(var json, String input) {
    for (var item in json) {
      if (item["ingredients"] == input) {
        return item;
      }
    }
  }

  bool listContainsAll<T>(List<T> a, List<T> b) {
    final setA = Set.of(a);
    return setA.containsAll(b);
  }
}





















 /*
    print("count ${copy.length}");
    for (var item in copy) {
      for (var value in data1) {
        if (value["url"] == item["url"]) {
          if (!item["imageUrl"].startsWith("https://firebasestorage.")) {
            Directory _photoDir = Directory('/storage/emulated/0/imgs/images');

            String filePath = '${_photoDir.path}/${value["id"]}.png';
            File file = File(filePath);
            print("indo ${file.path}");
            var recipesRef = storage.ref("recipes/${value["id"]}.png");
            try {
              var task = await recipesRef.putFile(file);
              var url = await task.ref.getDownloadURL();
              var copyItem = item.data();
              copyItem["imageUrl"] = url;
              await db.collection("recipes").doc(item.id).update(copyItem);
            } catch (e) {
              print(e);
              print("erro");
            }

            count += 1;
            break;
          }
          break;
        }
      }
    }
    print("foi ${count}");
*/
    /*
    
    final loadedData1 = await rootBundle.loadString('assets/sample_ing.json');
    var data1 = json.decode(loadedData1.trim());
    var db = FirebaseFirestore.instance;

    for (var item in data["data"]) {
      await db.collection("recipes").add({
        "title": item["title"],
        "infos": {
          "yield": item["infos"]["yield"],
          "preparation_time": item["infos"]["yield"]
        },
        "ingredients": item["ingredients"],
        "preparation": item["preparation"],
        "url": item["url"],
        "categories": item["categories"],
        "values": item["values"],
        "sizes": item["sizes"],
        "views": 0
      }).catchError((error) => print("Failed to add user: $error"));

      for (var value in item["values"]) {
        String convertedText = capitalizeEachWord(value.replaceAll("-", " "))
            .toTitleCase()
            .replaceAll(" ", "");
        var doc = await db.collection("ingredients").doc(convertedText).get();
        var result = doc.data();
        if (doc.exists) {
          result!["count"] += 1;
          await db.collection("ingredients").doc(convertedText).update(result);
        } else {
          var ing = getIng(data1, value);
          await db.collection("ingredients").doc(convertedText).set({
            "name": ing["ingredients"],
            "plural": ing["plural"],
            "count": 1
          }).catchError((error) => print("Failed to add user: $error"));
        }
      }
    }*/

    /* final loadedData1 = await rootBundle.loadString('assets/images_url.json');
    var data1 = json.decode(loadedData1.trim());
    var datax = await db.collection("recipes").get();
    var copy = datax.docs;
    int count = 0;

    print("count ${copy.length}");
    for (var item in copy) {
      for (var value in data1) {
        if (value["url"] == item["url"]) {
          Directory _photoDir = Directory('/storage/emulated/0/imgs/images');

          String filePath = '${_photoDir.path}/${value["id"]}.png';
          File file = File(filePath);
          print("indo ${file.path}");
          var recipesRef = storage.ref("recipes/${value["id"]}.png");
          try {
            var task = await recipesRef.putFile(file);
            var url = await task.ref.getDownloadURL();
            var copyItem = item.data();
            copyItem["imageUrl"] = url;
            await db.collection("recipes").doc(item.id).update(copyItem);
          } catch (e) {
            print(e);
            print("erro");
          }

          count += 1;
          break;
        }
      }
    }
    print("foi ${count}");*/