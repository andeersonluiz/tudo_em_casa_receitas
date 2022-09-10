import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';

import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tuple/tuple.dart';

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
  static const int limitRecipes = 10;
  static DocumentSnapshot? lastId;
  static DocumentSnapshot? lastIdFiltered;
  static DocumentSnapshot? lastIdField;
  static List<Recipe>? listFiltered;
  static List<Recipe>? listRecipes;
  static String lastQuery = "";
  getIngredients() async {
    await checkConnectivityStatus();
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

  static getRecipesByTagAndIngredients(
    List<Ingredient> ingredients,
    List<String> tags,
  ) async {
    final db = FirebaseFirestore.instance;

    List<String> ingredientsName = ingredients.map((e) => e.name).toList();
    Query<Map<String, dynamic>> docRef;

    DocumentSnapshot? lastId;
    Map myMap = {};
    await checkConnectivityStatus();

    for (String tag in tags) {
      myMap[tag] = [];
    }
    int totalCount = tags.length * limitRecipes;
    while (true) {
      if (lastId != null) {
        docRef = db
            .collection("recipes")
            .where("categories", arrayContainsAny: tags)
            .orderBy("views", descending: true)
            .startAfterDocument(lastId)
            .limit(1000);
      } else {
        docRef = db
            .collection("recipes")
            .where("categories", arrayContainsAny: tags)
            .orderBy("views", descending: true)
            .limit(1000);
      }
      var data = (await docRef.get()).docs;
      if (data.isEmpty) {
        break;
      }
      lastId = data[data.length - 1];
      for (var item in data) {
        if (listContainsAll(
            ingredientsName, List<String>.from(item.data()["values"]))) {
          Recipe rec;
          if (LocalVariables.idsListRecipes.contains(item.id)) {
            rec = Recipe.fromJson(
              item.data(),
              item.id,
              isFavorite: true,
            );
          } else {
            rec = Recipe.fromJson(
              item.data(),
              item.id,
            );
          }
          for (String tag in tags) {
            if (rec.categories.contains(tag) &&
                myMap[tag].length < limitRecipes) {
              myMap[tag] += [rec];
              totalCount -= 1;
            }
          }
        }
      }
      if (totalCount == 0) {
        List myList = [];
        for (var e in myMap.entries) {
          if (e.value.isNotEmpty) {
            myList.add([e.key, e.value]);
          }
        }

        return myList;
      }
    }
    List myList = [];
    for (var e in myMap.entries) {
      if (e.value.isNotEmpty) {
        myList.add([e.key, e.value]);
      }
    }
    return myList;
  }

  static getRecipesByTag(List<String> tags) async {
    List recipeByTag = [];
    final db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> results;
    await checkConnectivityStatus();

    for (String tag in tags) {
      if (tag.isEmpty) {
        results = await db
            .collection("recipes")
            .orderBy("views", descending: true)
            .limit(limitRecipes)
            .get();
      } else {
        results = await db
            .collection("recipes")
            .where("categories", arrayContains: tag)
            .limit(limitRecipes)
            .get();
      }
      var data = results.docs;
      var myRecipes = data.map((item) {
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
      recipeByTag.add([tag, myRecipes]);
    }

    return recipeByTag;
  }

  static getRecipes(Tuple3 field, {Tuple3? moreFilters}) async {
    await checkConnectivityStatus();
    try {
      final db = FirebaseFirestore.instance;
      var results = await db
          .collection("recipes")
          .orderBy(field.item2,
              descending: field.item3 == "desc" ? false : true)
          .get();
      var data = results.docs;

      List<Recipe> myList = data
          .map<Recipe>((item) => Recipe.fromJson(
                item.data(),
                item.id,
              ))
          .toList();

      listRecipes = myList;
      if (moreFilters != null) {
        return _sortListByField(listRecipes!, field.item2,
            moreFilters: moreFilters);
      }

      return listRecipes;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw "Error";
    }
  }

  static filterSearch(Tuple3 field, String queryText,
      {Tuple3? moreFilters}) async {
    final db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> results;
    await checkConnectivityStatus();

    results = await db
        .collection("recipes")
        .orderBy(field.item2, descending: field.item3 == "desc" ? false : true)
        .get();

    lastQuery = queryText;

    var data = results.docs;

    var myRecipes = data.map((item) {
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
    listFiltered = myRecipes
        .where((element) => removeDiacritics(element.title)
            .toLowerCase()
            .trim()
            .contains(removeDiacritics(queryText).toLowerCase().trim()))
        .toList();

    if (moreFilters != null) {
      return _sortListByField(listFiltered!, field.item2,
          moreFilters: moreFilters);
    }

    return listFiltered;
  }

  static filterResults(Tuple3 field,
      {Tuple3? moreFilters, bool isFilter = true}) async {
    List<Recipe> copyListFiltered =
        List<Recipe>.from(isFilter ? listFiltered! : listRecipes!);
    await checkConnectivityStatus();
    try {
      return _sortListByField(copyListFiltered, field.item2.toString(),
          moreFilters: moreFilters,
          descending: field.item3 == "asc" ? false : true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static _sortListByField(List<Recipe> listComposed, String field,
      {bool descending = true, Tuple3? moreFilters}) {
    if (moreFilters != null) {
      switch (moreFilters.item2) {
        case "infos.preparation_time":
          listComposed = listComposed.where((element) {
            if (moreFilters.item3 == ">") {
              return element.infos.preparationTime > (moreFilters.item1 as int);
            } else {
              return element.infos.preparationTime <=
                  (moreFilters.item1 as int);
            }
          }).toList();
      }
    }
    if (descending) {
      switch (field) {
        case "favorites":
          listComposed.sort((a, b) {
            int comp = b.favorites.compareTo(a.favorites);
            if (comp == 0) {
              return a.title.compareTo(b.title);
            }
            return comp;
          });
          break;
        case "views":
          listComposed.sort((a, b) {
            int comp = b.views.compareTo(a.views);
            if (comp == 0) {
              return a.title.compareTo(b.title);
            }
            return comp;
          });
          break;
        case "createdOn":
          listComposed.sort((a, b) => b.createdOn.compareTo(a.createdOn));
          break;
        case "updatedOn":
          listComposed.sort((a, b) => b.updatedOn.compareTo(a.updatedOn));
          break;
      }
    } else {
      switch (field) {
        case "favorites":
          listComposed.sort((a, b) {
            int comp = a.favorites.compareTo(b.favorites);
            if (comp == 0) {
              return a.title.compareTo(b.title);
            }
            return comp;
          });
          break;
        case "views":
          listComposed.sort((a, b) {
            int comp = a.views.compareTo(b.views);
            if (comp == 0) {
              return a.title.compareTo(b.title);
            }
            return comp;
          });
          break;
        case "createdOn":
          listComposed.sort((a, b) => a.createdOn.compareTo(b.createdOn));
          break;
        case "updatedOn":
          listComposed.sort((a, b) => a.updatedOn.compareTo(b.updatedOn));
          break;
      }
    }
    return listComposed;
  }

  static String removeDiacritics(String str) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  static bool listContainsAll<T>(List<T> a, List<T> b) {
    final setA = Set.of(a);
    return setA.containsAll(b);
  }

  static checkConnectivityStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw "no_connection";
    }
  }
}
