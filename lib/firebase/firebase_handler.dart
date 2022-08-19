import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'dart:convert';

import 'package:tudo_em_casa_receitas/model/recipe_model.dart';

class FirebaseBaseHelper {
  getIngredients() async {
    final loadedData = await rootBundle.loadString('assets/sample00x.json');
    var data = json.decode(loadedData.trim());

    CollectionReference db = FirebaseFirestore.instance.collection("recipes");
    for (var item in data["data"]) {
      print(item);
      await db.add({
        'full_name': '1', // John Doe
        'company': 'company', // Stokes and Sons
        'age': 'age' // 42
      }).catchError((error) => print("Failed to add user: $error"));
      ;
    }
/*
    List<Ingredient> myList =
        data.map<Ingredient>((item) => Ingredient.fromJson(item)).toList();
    myList.sort((a, b) => a.searchValue.compareTo(b.searchValue));
    return myList;*/
  }

  getRecipes() async {
    final loadedData = await rootBundle.loadString('assets/recipes.json');
    var data = json.decode(loadedData.trim());
    List<Recipe> myList =
        data.map<Recipe>((item) => Recipe.fromJson(item)).toList();
    myList.sort((a, b) => a.title.compareTo(b.title));

    return myList;
  }
}
