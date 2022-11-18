import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/categorie_list_model.dart';
import 'package:tudo_em_casa_receitas/model/categorie_model.dart';
import 'package:tudo_em_casa_receitas/model/user_info_model.dart' as model;

import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';

import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';
import 'package:tuple/tuple.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../model/recipe_user_model.dart';

@pragma('vm:entry-point')
updateRecipesUser(var data) {
  for (var item in data[0]) {
    var rec = Recipe.fromJson(item.data(), item.reference.id);
    rec.userInfo = data[1];
    FirebaseFirestore.instance
        .collection("recipes")
        .doc(item.reference.id)
        .update(rec.toJson());
  }
  // Heavy computing process

  return true;
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

//TESTAR AMANAH

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
  static List<Recipe>? listRecipeCategory;
  static List<Recipe>? listRecipeUser;
  static List<List<Recipe>>? listRecipeResult;
  static List<String> lastIngredientsName = [];
  static String lastQuery = "";
  static int indexPaginationRecipesByTag = 0;
  static getIngredients() async {
    await checkConnectivityStatus();
    var results =
        FirebaseFirestore.instance.collection("ingredients").orderBy("name");
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

  static getMeasures() async {
    await checkConnectivityStatus();
    try {
      final db = FirebaseFirestore.instance;
      var results =
          (await db.collection("measures").orderBy("name").get()).docs;
      var list = results.map((e) => Measure.fromJson(e.data())).toList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static getCategories() async {
    await checkConnectivityStatus();
    try {
      final db = FirebaseFirestore.instance;
      var results =
          (await db.collection("categories").orderBy("name").get()).docs;
      var list = results.map((e) => Categorie.fromJson(e.data())).toList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static initalizeCategoriesList() async {
    await checkConnectivityStatus();
    try {
      final db = FirebaseFirestore.instance;
      var results =
          (await db.collection("categories").orderBy("name").get()).docs;

      List<CategorieList> list = [];
      for (var e in results) {
        list.add(CategorieList.fromJson(e.data()));
      }

      for (CategorieList cat in list) {
        var size = (await db
                .collection("recipes")
                .where("categories", arrayContains: cat.name.toUpperCase())
                .get())
            .docs
            .length;
        cat.count = size;
      }
      list.sort((a, b) => b.count.compareTo(a.count));
      int index = 0;
      for (CategorieList cat in list) {
        if (index <= 10) {
          cat.count = 10;
        } else {
          cat.count = 1;
        }
        index += 1;
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  /* static getRecipesByTagAndIngredients(
    List<Ingredient> ingredients,
    List<String> tags,
    UserModel currentUser,
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
          var isLiked = false, isFavorite = false;

          if (currentUser.recipeLikes.contains(item.id)) {
            isLiked = true;
          }
          if (LocalVariables.idsListRecipes.contains(item.id)) {
            isFavorite = true;
          }
          rec = Recipe.fromJson(
            item.data(),
            item.id,
            isLiked: isLiked,
            isFavorite: isFavorite,
          );

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
        break;
      }
    }
    List myList = [];
    for (var e in myMap.entries) {
      if (e.value.isNotEmpty) {
        myList.add([e.key, e.value]);
      }
    }
    return myList;
  }*/

  static getRecipesResults(UserModel currentUser) async {
    List<String> allIngredientsName = (LocalVariables.ingredientsPantry +
            LocalVariables.ingredientsHomePantry)
        .map((e) => e.name)
        .toList();
    allIngredientsName.sort();
    String ingNames = allIngredientsName.join(";;");

    print(ingNames);
    await checkConnectivityStatus();
    final db = FirebaseFirestore.instance;
    var ref = db.collection("recipes").orderBy("views", descending: true);
    var data = (await ref.get()).docs;
    var map = {"containsAll": <Recipe>[], "MissingOne": <Recipe>[]};

    for (var item in data) {
      var values = List<String>.from(item.data()["values"]);
      if (values[0].contains(";;")) {
        for (var valueItem in values) {
          var listIngredients = valueItem.split(";;");
          if (listContainsAll(allIngredientsName, listIngredients)) {
            Recipe rec;
            var isLiked = false, isFavorite = false;

            if (currentUser.recipeLikes.contains(item.id)) {
              isLiked = true;
            }
            if (LocalVariables.idsListRecipes.contains(item.id)) {
              isFavorite = true;
            }
            rec = Recipe.fromJson(
              item.data(),
              item.id,
              isLiked: isLiked,
              isFavorite: isFavorite,
            );

            map["containsAll"] = map["containsAll"]! + [rec];
          } else if (listContainsMissingOne(allIngredientsName, listIngredients)
                      .length ==
                  1 &&
              listIngredients.length > 1) {
            Recipe rec;
            String missingIngredient =
                listContainsMissingOne(allIngredientsName, listIngredients)
                    .first;
            var isLiked = false, isFavorite = false;

            if (currentUser.recipeLikes.contains(item.id)) {
              isLiked = true;
            }
            if (LocalVariables.idsListRecipes.contains(item.id)) {
              isFavorite = true;
            }
            rec = Recipe.fromJson(
              item.data(),
              item.id,
              isLiked: isLiked,
              isFavorite: isFavorite,
              missingIngredient: missingIngredient,
            );

            map["MissingOne"] = map["MissingOne"]! + [rec];
          }
        }
      } else {
        if (listContainsAll(
          allIngredientsName,
          List<String>.from(item.data()["values"]),
        )) {
          Recipe rec;
          var isLiked = false, isFavorite = false;

          if (currentUser.recipeLikes.contains(item.id)) {
            isLiked = true;
          }
          if (LocalVariables.idsListRecipes.contains(item.id)) {
            isFavorite = true;
          }
          rec = Recipe.fromJson(
            item.data(),
            item.id,
            isLiked: isLiked,
            isFavorite: isFavorite,
          );

          map["containsAll"] = map["containsAll"]! + [rec];
        } else if (listContainsMissingOne(allIngredientsName,
                        List<String>.from(item.data()["values"]))
                    .length ==
                1 &&
            List<String>.from(item.data()["values"]).length > 1) {
          Recipe rec;
          String missingIngredient = listContainsMissingOne(
                  allIngredientsName, List<String>.from(item.data()["values"]))
              .first;
          var isLiked = false, isFavorite = false;

          if (currentUser.recipeLikes.contains(item.id)) {
            isLiked = true;
          }
          if (LocalVariables.idsListRecipes.contains(item.id)) {
            isFavorite = true;
          }
          rec = Recipe.fromJson(
            item.data(),
            item.id,
            isLiked: isLiked,
            isFavorite: isFavorite,
            missingIngredient: missingIngredient,
          );

          map["MissingOne"] = map["MissingOne"]! + [rec];
        }
      }
    }
    List<List<Recipe>> myList = [];
    int countBlank = 0;
    for (var e in map.entries) {
      if (e.value.isEmpty) {
        countBlank += 1;
        myList.add([]);
      } else {
        myList.add(e.value);
      }
    }
    if (countBlank == myList.length) {
      listRecipeResult = myList;
      return [];
    }
    listRecipeResult = myList;
    return listRecipeResult;
  }

  static getRecipesByTags(List<String> tags, UserModel currentUser) async {
    List recipeByTag = [];
    final db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> results;

    await checkConnectivityStatus();

    for (String tag in tags.take(10)) {
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
        var isLiked = false, isFavorite = false;

        if (currentUser.recipeLikes.contains(item.id)) {
          isLiked = true;
        }
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }
        return Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        );
      }).toList();
      myRecipes.shuffle();
      recipeByTag.add([tag, myRecipes]);
    }
    indexPaginationRecipesByTag = 9;
    return recipeByTag;
  }

  static getMoreRecipesByTags(List<String> tags, UserModel currentUser) async {
    List recipeByTag = [];
    final db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> results;
    try {
      await checkConnectivityStatus();

      for (String tag in tags.sublist(indexPaginationRecipesByTag).take(10)) {
        results = await db
            .collection("recipes")
            .where("categories", arrayContains: tag)
            .limit(limitRecipes)
            .get();
        var data = results.docs;
        if (data.length < 4) {
          continue;
        }
        var myRecipes = data.map((item) {
          var isLiked = false, isFavorite = false;

          if (currentUser.recipeLikes.contains(item.id)) {
            isLiked = true;
          }
          if (LocalVariables.idsListRecipes.contains(item.id)) {
            isFavorite = true;
          }
          return Recipe.fromJson(
            item.data(),
            item.id,
            isLiked: isLiked,
            isFavorite: isFavorite,
          );
        }).toList();
        myRecipes.shuffle();
        recipeByTag.add([tag, myRecipes]);
      }
      indexPaginationRecipesByTag += 10;
      return recipeByTag;
    } catch (e) {
      return [];
    }
  }

  static getRecipesByTag(String tag, UserModel currentUser) async {
    final db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> results;
    await checkConnectivityStatus();
    try {
      if (tag.isEmpty) {
        results = await db
            .collection("recipes")
            .orderBy("views", descending: true)
            .get();
      } else {
        results = await db
            .collection("recipes")
            .where("categories", arrayContains: tag)
            .get();
      }

      var data = results.docs;
      var myRecipes = data.map((item) {
        var isLiked = false, isFavorite = false;

        if (currentUser.recipeLikes.contains(item.id)) {
          isLiked = true;
        }
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }
        return Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        );
      }).toList();
      listRecipeCategory = myRecipes;
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0014)";
    }

    return listRecipeCategory;
  }

  static getRecipes(Tuple3 field, UserModel currentUser,
      {Tuple3? moreFilters}) async {
    await checkConnectivityStatus();
    try {
      final db = FirebaseFirestore.instance;
      var results = await db
          .collection("recipes")
          .orderBy(field.item2,
              descending: field.item3 == "desc" ? false : true)
          .get();
      var data = results.docs;

      List<Recipe> myList = data.map<Recipe>((item) {
        bool isLiked = false, isFavorite = false;
        if (currentUser.recipeLikes.contains(item.id)) {
          isLiked = true;
        }
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }
        return Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        );
      }).toList();

      listRecipes = myList;
      if (moreFilters != null) {
        return _sortListByField(listRecipes!, field.item2,
            moreFilters: moreFilters);
      }

      return listRecipes;
    } catch (e) {
      if (foundation.kDebugMode) {
        //print(e);
      }
      throw "Error";
    }
  }

  static filterSearch(Tuple3 field, String queryText, UserModel currentUser,
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
      var isLiked = false, isFavorite = false;

      if (currentUser.recipeLikes.contains(item.id)) {
        isLiked = true;
      }
      if (LocalVariables.idsListRecipes.contains(item.id)) {
        isFavorite = true;
      }
      return Recipe.fromJson(
        item.data(),
        item.id,
        isLiked: isLiked,
        isFavorite: isFavorite,
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

  static filterResults(Tuple3 field, ListType listType,
      {Tuple3? moreFilters}) async {
    List<Recipe> copyListFiltered = List<Recipe>.from(getListByType(listType));
    await checkConnectivityStatus();
    try {
      return _sortListByField(copyListFiltered, field.item2.toString(),
          moreFilters: moreFilters,
          descending: field.item3 == "asc" ? false : true);
    } catch (e) {
      if (foundation.kDebugMode) {
        //print(e);
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

  /* LOGIN/REGISTER */
  static registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      await checkConnectivityStatus();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var urlImage = await FirebaseStorage.instance
          .ref()
          .child("default_icon.png")
          .getDownloadURL();
      var wallpaperImage = await FirebaseStorage.instance
          .ref()
          .child("background.png")
          .getDownloadURL();
      var token = await FirebaseMessaging.instance.getToken();
      var user = UserModel(
        id: FirebaseAuth.instance.currentUser!.uid,
        idFirestore: "",
        name: name,
        image: urlImage,
        recipeList: [],
        deviceToken: token!,
        wallpaperImage: wallpaperImage,
        recipeLikes: [],
        followers: 0,
        description: "",
        followersList: [],
        followingList: [],
        following: 0,
      );
      var result = await FirebaseFirestore.instance
          .collection("users")
          .add(UserModel.toMap(user));
      user.idFirestore = result.id;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(result.id)
          .update(UserModel.toMap(user));

      result.id;

      return user;
    } on FirebaseAuthException catch (authError) {
      switch (authError.code) {
        case "email-already-in-use":
          return "Email já em uso.";
        case "invalid-email":
          return "Email inválido.";
        case "operation-not-allowed":
          return "Operação não permitida.";
        case "weak-password":
          return "Senha deve possuir no minimo 8 caracteres.";
      }
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0001)";
    }
  }

  static loginWithEmailAndPassword(String email, String password) async {
    try {
      await checkConnectivityStatus();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      return UserModel.fromJson(user.docs[0].data());
    } on FirebaseAuthException catch (authError) {
      switch (authError.code) {
        case "user-disabled":
          return "Usuario desabilido. Entre em contato com um adminstrador";
        case "invalid-email":
          return "Email inválido.";
        case "user-not-found":
          return "Usuário não encontrado.";
        case "wrong-password":
          return "Senha errada, tente novamente.";
      }
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0002)";
    }
  }

  static resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Email de recuperação enviado. Verifique no seu email ou caixa de spam.";
    } on FirebaseAuthException catch (authError) {
      switch (authError.code) {
        case "invalid-email":
          return "invalid-email";
        case "missing-android-pkg-name":
          return "Email inválido.";
        case "missing-continue-uri":
          return "Usuário não encontrado.";
        case "missing-ios-bundle-id":
          return "Senha errada, tente novamente.";
        case "unauthorized-continue-uri":
          return "Senha errada, tente novamente.";
        case "user-not-found":
          return "Usuário não encontrado";
        case "invalid-continue-uri":
          return "Senha errada, tente novamente.";
      }
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0003)";
    }
  }

  static dynamic registerWithGoogle() async {
    try {
      await checkConnectivityStatus();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        var urlImage = await FirebaseStorage.instance
            .ref()
            .child("default_icon.png")
            .getDownloadURL();
        var wallpaperImage = await FirebaseStorage.instance
            .ref()
            .child("background.png")
            .getDownloadURL();
        var token = await FirebaseMessaging.instance.getToken();
        var user = UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          idFirestore: "",
          name: userCredential.user!.displayName!,
          image: urlImage,
          followers: 0,
          recipeList: [],
          deviceToken: token!,
          description: "",
          wallpaperImage: wallpaperImage,
          recipeLikes: [],
          followersList: [],
          followingList: [],
          following: 0,
        );
        var result = await FirebaseFirestore.instance
            .collection("users")
            .add(UserModel.toMap(user));
        user.idFirestore = result.id;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(result.id)
            .update(UserModel.toMap(user));
        return user;
      } else {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();

        return "Usuario já cadastrado, faça o login.";
      }
    } on FirebaseAuthException catch (authError) {
      switch (authError.code) {
        case "account-exists-with-different-credential":
          return authError.code;
        case "invalid-credential":
          return authError.code;
        case "operation-not-allowed":
          return authError.code;
        case "user-disabled":
          return authError.code;
        case "user-not-found":
          return authError.code;
        case "wrong-password":
          return authError.code;
        case "invalid-verification-code":
          return authError.code;
        case "invalid-verification-id":
          return authError.code;
      }
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0004)";
    }
  }

  static loginWithGoogle() async {
    try {
      await checkConnectivityStatus();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        return "Não há usuario cadastrado, faça o registro.";
      } else {
        var user = await FirebaseFirestore.instance
            .collection("users")
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
        return UserModel.fromJson(user.docs[0].data());
      }
      //FirebaseFirestore.instance.collection("users").where("id")
    } on FirebaseAuthException catch (authError) {
      switch (authError.code) {
        case "account-exists-with-different-credential":
          return authError.code;
        case "invalid-credential":
          return authError.code;
        case "operation-not-allowed":
          return authError.code;
        case "user-disabled":
          return authError.code;
        case "user-not-found":
          return authError.code;
        case "wrong-password":
          return authError.code;
        case "invalid-verification-code":
          return authError.code;
        case "invalid-verification-id":
          return authError.code;
      }
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0005)";
    }
  }

  static logOut() async {
    await FirebaseAuth.instance.signOut();

    //await GoogleSignIn().signOut();
  }

  static deleteIngredientsRevised(List<Ingredient> ingredients) async {
    var listIds = ingredients.map((e) => e.id).toList();

    var results = await FirebaseFirestore.instance
        .collection("revisionsIngredients")
        .where("id", whereIn: listIds)
        .get();
    for (var ingredient in results.docs) {
      await FirebaseFirestore.instance
          .collection("revisionsIngredients")
          .doc(ingredient.id)
          .delete();
    }
  }

  static deleteMeasureRevised(List<Measure> measures) async {
    var listNames =
        measures.map((e) => e.name.toString().toLowerCase().trim()).toList();

    var results = await FirebaseFirestore.instance
        .collection("revisionsMeasure")
        .where("name", whereIn: listNames)
        .get();
    for (var measure in results.docs) {
      await FirebaseFirestore.instance
          .collection("revisionsMeasure")
          .doc(measure.id)
          .delete();
    }
  }

  static deleteCategorieRevised(List<Categorie> categories) async {
    var listNames =
        categories.map((e) => e.name.toString().toLowerCase().trim()).toList();

    var results = await FirebaseFirestore.instance
        .collection("revisionsCategories")
        .where("name", whereIn: listNames)
        .get();
    for (var categorie in results.docs) {
      await FirebaseFirestore.instance
          .collection("revisionsCategories")
          .doc(categorie.id)
          .delete();
    }
  }

  static getUserData(
    String id,
  ) async {
    var result = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: id)
        .get();

    return UserModel.fromJson(result.docs[0].data());
  }

  static saveUserData(UserModel user) async {
    var result = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: user.id)
        .get();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(result.docs.first.id)
        .update(UserModel.toMap(user));
  }

  static sendIngredientToRevision(
      Ingredient ingredient, UserModel currentUser) async {
    try {
      await checkConnectivityStatus();
      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: currentUser.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }
      ingredient.userId = currentUser.id;
      await FirebaseFirestore.instance
          .collection("revisionsIngredients")
          .add(ingredient.toJson());

      return "";
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0006)";
    }
  }

  static sendMeasureToRevision(Measure measure, UserModel currentUser) async {
    try {
      await checkConnectivityStatus();
      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: currentUser.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }
      measure.userId = currentUser.id;
      await FirebaseFirestore.instance
          .collection("revisionsMeasure")
          .add(measure.toJson());

      return "";
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0007)";
    }
  }

  static sendCategorieToRevision(
      Categorie categorie, UserModel currentUser) async {
    try {
      await checkConnectivityStatus();
      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: currentUser.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }
      categorie.userId = currentUser.id;
      await FirebaseFirestore.instance
          .collection("revisionsCategories")
          .add(categorie.toJson());

      return "";
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0008)";
    }
  }

  static getMyRecipes(UserModel currentUser) async {
    try {
      await checkConnectivityStatus();
      if (currentUser.recipeList.isEmpty) {
        return [];
      }
      var result = [];
      var results = await FirebaseFirestore.instance
          .collection("recipes")
          .where("userInfo.idUser", isEqualTo: currentUser.id)
          .get();
      for (var item in results.docs) {
        var isLiked = false, isFavorite = false;

        if (currentUser.recipeLikes.contains(item.id)) {
          isLiked = true;
        }
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }

        result.add(Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        ));
      }
      print(result.first.title);
      var resultsRevision = await getMyRecipesRevisions(currentUser);
      var resultsUnion = List<Recipe>.from(resultsRevision + result);

      resultsUnion.sort((a, b) {
        int cmp = b.statusRecipe.index.compareTo(a.statusRecipe.index);
        if (cmp != 0) return cmp;
        return b.updatedOn.compareTo(a.updatedOn);
      });
      print(resultsUnion.first.title);
      return resultsUnion;
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0009)";
    }
  }

  static getMyRecipesRevisions(UserModel currentUser) async {
    try {
      await checkConnectivityStatus();
      if (currentUser.recipeList.isEmpty) {
        return [];
      }

      var result = [];
      var results = await FirebaseFirestore.instance
          .collection("revisionRecipes")
          .where("userInfo.idUser", isEqualTo: currentUser.id)
          .orderBy("updatedOn", descending: true)
          .get();
      for (var item in results.docs) {
        var isLiked = false, isFavorite = false;

        if (currentUser.recipeLikes.contains(item.id)) {
          isLiked = true;
        }
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }
        result.add(Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        ));
      }

      return result;
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0019)";
    }
  }

  static getRecipesFromUser(UserModel currentUser,
      {int? crossAxisCount}) async {
    try {
      await checkConnectivityStatus();
      QuerySnapshot<Map<String, dynamic>> results;
      if (crossAxisCount == null) {
        results = await FirebaseFirestore.instance
            .collection("recipes")
            .where("userInfo.idUser", isEqualTo: currentUser.id)
            .orderBy("views")
            .get();
      } else {
        var countItens = ((10 / crossAxisCount).floor()) * crossAxisCount;
        results = await FirebaseFirestore.instance
            .collection("recipes")
            .where("userInfo.idUser", isEqualTo: currentUser.id)
            .orderBy("views")
            .limit(countItens)
            .get();
      }
      List<Recipe> result = [];

      for (var item in results.docs) {
        var isLiked = false, isFavorite = false;

        if (currentUser.recipeLikes.contains(item.id)) {
          isLiked = true;
        }
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }
        result.add(Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        ));
      }
      listRecipeUser = result;
      return result;
    } catch (e) {
      return "Erro inesperado. Tente novamente mais tarde(0009)";
    }
  }

  static addRecipe(Recipe recipe, UserModel currentUser,
      {bool isRevision = false}) async {
    try {
      await checkConnectivityStatus();

      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: currentUser.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }

      if (isRevision) {
        DocumentReference ref =
            FirebaseFirestore.instance.collection("revisionRecipes").doc();
        recipe.id = ref.id;
        var file = await FirebaseStorage.instance
            .ref("users/${result.docs[0].reference.id}")
            .child("background_${recipe.id}_revision")
            .putFile(File(recipe.imageUrl));
        recipe.imageUrl = await file.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("revisionRecipes")
            .doc(ref.id)
            .set(recipe.toJson());
      } else {
        DocumentReference ref =
            FirebaseFirestore.instance.collection("recipes").doc();
        recipe.id = ref.id;
        var file = await FirebaseStorage.instance
            .ref("users/${result.docs[0].reference.id}")
            .child("background_${recipe.id}")
            .putFile(File(recipe.imageUrl));
        recipe.imageUrl = await file.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("recipes")
            .doc(ref.id)
            .set(recipe.toJson());
      }

      currentUser.recipeList.add(RecipeUser(
          id: recipe.id,
          isRevision: recipe.statusRecipe == StatusRevisionRecipe.Checked
              ? false
              : true));
      await FirebaseFirestore.instance
          .collection("users")
          .doc(result.docs[0].reference.id)
          .update(UserModel.toMap(currentUser));
      Preferences.saveUser(
        currentUser,
        addRecipe: true,
        recipe: recipe,
      );
      return "";
    } catch (e) {
      return "Erro ao adicionar receita, tente novamente mais tarde(0010)";
    }
  }

  static updateRecipe(Recipe recipe, UserModel currentUser,
      {required bool isRevisionChange, bool isRevision = false}) async {
    try {
      print("the recipe.id is ${recipe.id}");
      await checkConnectivityStatus();
      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: currentUser.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }

      String refToDelete = "";
      String idToDelete = "";
      //resolver essa parte aq
//isRevision revisionChange
// true true => recipes
// true false => revisionRecipes
// false true => revisionRecipes
// false false => recipes

      if (isRevisionChange) {
        if (isRevision) {
          idToDelete = recipe.id;
          DocumentReference ref =
              FirebaseFirestore.instance.collection("recipes").doc();
          recipe.id = ref.id;
          if (!recipe.imageUrl.startsWith("https://firebase")) {
            var file = await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${recipe.id}")
                .putFile(File(recipe.imageUrl));
            recipe.imageUrl = await file.ref.getDownloadURL();
          } else {
            var urlOld = await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${idToDelete}_revision")
                .getDownloadURL();
            final http.Response responseData =
                await http.get(Uri.parse(urlOld));
            await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${recipe.id}")
                .putData(responseData.bodyBytes);
            recipe.imageUrl = await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${recipe.id}")
                .getDownloadURL();
          }
          recipe.statusRecipe = StatusRevisionRecipe.Checked;
          await FirebaseFirestore.instance
              .collection("recipes")
              .doc(ref.id)
              .set(recipe.toJson());
          await FirebaseStorage.instance
              .ref("users/${result.docs[0].reference.id}")
              .child("background_${idToDelete}_revision")
              .delete();
          refToDelete = "revisionRecipes";
        } else {
          idToDelete = recipe.id;
          recipe.statusRecipe = StatusRevisionRecipe.Revision;
          DocumentReference ref =
              FirebaseFirestore.instance.collection("revisionRecipes").doc();
          recipe.id = ref.id;
          if (!recipe.imageUrl.startsWith("https://firebase")) {
            var file = await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${recipe.id}_revision")
                .putFile(File(recipe.imageUrl));
            recipe.imageUrl = await file.ref.getDownloadURL();
          } else {
            var urlOld = await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_$idToDelete")
                .getDownloadURL();
            final http.Response responseData =
                await http.get(Uri.parse(urlOld));
            await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${recipe.id}_revision")
                .putData(responseData.bodyBytes);
            recipe.imageUrl = await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${recipe.id}_revision")
                .getDownloadURL();
          }
          await FirebaseFirestore.instance
              .collection("revisionRecipes")
              .doc(ref.id)
              .set(recipe.toJson());
          await FirebaseStorage.instance
              .ref("users/${result.docs[0].reference.id}")
              .child("background_$idToDelete")
              .delete();
          refToDelete = "recipes";
        }
      } else {
        if (isRevision) {
          recipe.statusRecipe = StatusRevisionRecipe.Revision;
          if (!recipe.imageUrl.startsWith("https://firebase")) {
            var file = await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${recipe.id}_recipe")
                .putFile(File(recipe.imageUrl));
            recipe.imageUrl = await file.ref.getDownloadURL();
          }
          await FirebaseFirestore.instance
              .collection("revisionRecipes")
              .doc(recipe.id)
              .update(recipe.toJson());
        } else {
          recipe.statusRecipe = StatusRevisionRecipe.Checked;
          if (!recipe.imageUrl.startsWith("https://firebase")) {
            var file = await FirebaseStorage.instance
                .ref("users/${result.docs[0].reference.id}")
                .child("background_${recipe.id}")
                .putFile(File(recipe.imageUrl));
            recipe.imageUrl = await file.ref.getDownloadURL();
          }
          await FirebaseFirestore.instance
              .collection("recipes")
              .doc(recipe.id)
              .update(recipe.toJson());
        }
      }
      if (refToDelete != "") {
        await FirebaseFirestore.instance
            .collection(refToDelete)
            .doc(idToDelete)
            .delete();

        print(currentUser.recipeList.first.id);
        print("new id ${recipe.id}");
        print(idToDelete);
        print(currentUser.recipeList
            .indexWhere((element) => element.id == idToDelete));
        currentUser.recipeList[currentUser.recipeList
                .indexWhere((element) => element.id == idToDelete)] =
            RecipeUser(
                id: recipe.id,
                isRevision: recipe.statusRecipe == StatusRevisionRecipe.Checked
                    ? false
                    : true);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(result.docs[0].reference.id)
            .update(UserModel.toMap(currentUser));
      } else {
        currentUser.recipeList[currentUser.recipeList
                .indexWhere((element) => element.id == recipe.id)] =
            RecipeUser(
                id: recipe.id,
                isRevision: recipe.statusRecipe == StatusRevisionRecipe.Checked
                    ? false
                    : true);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(result.docs[0].reference.id)
            .update(UserModel.toMap(currentUser));
      }
      Preferences.saveUser(currentUser,
          updateRecipe: true, recipe: recipe, lastId: idToDelete);
      return "";
    } catch (e, stacktrace) {
      print(stacktrace);
      return "Erro ao atualizar receita, tente novamente mais tarde(0011)";
    }
  }

  static updateRecipeLike(Recipe recipe, UserModel currentUser) async {
    try {
      await checkConnectivityStatus();

      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: currentUser.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }
      if (currentUser.recipeLikes.contains(recipe.id)) {
        currentUser.recipeLikes.remove(recipe.id);
        await FirebaseFirestore.instance
            .collection("recipes")
            .doc(recipe.id)
            .update({"likes": FieldValue.increment(-1)});
      } else {
        currentUser.recipeLikes.add(recipe.id);
        await FirebaseFirestore.instance
            .collection("recipes")
            .doc(recipe.id)
            .update({"likes": FieldValue.increment(1)});
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(result.docs[0].reference.id)
          .update(UserModel.toMap(currentUser));
      Preferences.saveUser(currentUser, recipe: recipe);
      return "";
    } catch (e) {
      return "Erro ao atualizar receita qtd, tente novamente mais tarde(0012)";
    }
  }

  static deleteRecipe(
    Recipe recipe,
    UserModel currentUser,
  ) async {
    try {
      await checkConnectivityStatus();

      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: currentUser.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }

      if (recipe.statusRecipe == StatusRevisionRecipe.Revision ||
          recipe.statusRecipe == StatusRevisionRecipe.Error) {
        await FirebaseFirestore.instance
            .collection("revisionRecipes")
            .doc(recipe.id)
            .delete();
        await FirebaseStorage.instance
            .ref("users/${result.docs[0].reference.id}")
            .child("background_${recipe.id}_revision")
            .delete();
      } else {
        await FirebaseFirestore.instance
            .collection("recipes")
            .doc(recipe.id)
            .delete();
        await FirebaseStorage.instance
            .ref("users/${result.docs[0].reference.id}")
            .child("background_${recipe.id}")
            .delete();
      }

      currentUser.recipeList.removeWhere((element) => element.id == recipe.id);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(result.docs[0].reference.id)
          .update(UserModel.toMap(currentUser));

      Preferences.saveUser(currentUser, deleteRecipe: true, recipe: recipe);
      return "";
    } catch (e) {
      return "Erro ao deletar receita, tente novamente mais tarde(0013)";
    }
  }

  static updateUser(UserModel user, {bool modifyUserInfo = false}) async {
    try {
      await checkConnectivityStatus();
      bool modifyImage = false;
      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: user.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }
      if (!user.wallpaperImage.startsWith("https://firebasestorage")) {
        var res = await FirebaseStorage.instance
            .ref("users/${result.docs[0].reference.id}/images")
            .child("wallpaper_profile")
            .putFile(File(user.wallpaperImage));
        user.wallpaperImage = await res.ref.getDownloadURL();
      }
      if (!user.image.startsWith("https://firebasestorage")) {
        var res = await FirebaseStorage.instance
            .ref("users/${result.docs[0].reference.id}/images")
            .child("image_profile")
            .putFile(File(user.image));
        user.image = await res.ref.getDownloadURL();
        modifyImage = true;
      }
      var db = FirebaseFirestore.instance;
      if (modifyImage || modifyUserInfo) {
        var batch = db.batch();
        var results = await FirebaseFirestore.instance
            .collection("recipes")
            .where("userInfo.idUser", isEqualTo: user.id)
            .get();
        var count = 0;
        for (int i = 0; i < results.docs.length; i++) {
          if (count == 500) {
            batch.commit();

            batch = db.batch();
            count = 0;
          }
          var rec = Recipe.fromJson(
              results.docs[i].data(), results.docs[i].data()["id"]);
          rec.userInfo = model.UserInfo(
              idUser: user.id,
              name: user.name,
              imageUrl: user.image,
              followers: user.followers);
          var ref = db.collection("recipes").doc(rec.id);

          batch.update(ref, rec.toJson());
          count += 1;
        }
        if (count != 0) {
          batch.commit();
        }
      }
      await FirebaseFirestore.instance
          .collection("users")
          .doc(result.docs[0].id)
          .update(UserModel.toMap(user));
      Preferences.saveUser(user);
      return "";
    } catch (e) {
      return "Erro ao salvar dados, tente novamente mais tarde";
    }
  }

  static updateUsers(UserModel currentUser, UserModel profileUser) async {
    try {
      await checkConnectivityStatus();
      var result = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: currentUser.id)
          .get();
      if (result.docs.isEmpty) {
        return "Usuario não logado, reinicie o aplicativo";
      }
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.idFirestore)
          .update(UserModel.toMap(currentUser));
      await FirebaseFirestore.instance
          .collection("users")
          .doc(profileUser.idFirestore)
          .update(UserModel.toMap(profileUser));
      Preferences.saveUser(currentUser);
      return "";
    } catch (e) {
      return "Erro ao salvar dados, tente novamente mais tarde";
    }
  }

  static getFavorites(List<String> listIds, UserModel currentUser) async {
    if (listIds.isEmpty) return [];
    var results = await FirebaseFirestore.instance
        .collection("recipes")
        .where("id", whereIn: listIds)
        .orderBy("views")
        .get();
    var data = results.docs;
    var myRecipes = data.map((item) {
      var isLiked = false, isFavorite = false;

      if (currentUser.recipeLikes.contains(item.id)) {
        isLiked = true;
      }
      if (LocalVariables.idsListRecipes.contains(item.id)) {
        isFavorite = true;
      }
      return Recipe.fromJson(
        item.data(),
        item.id,
        isLiked: isLiked,
        isFavorite: isFavorite,
      );
    }).toList();
    return myRecipes;
  }

  static sendFeedback(UserModel currentUser, String feedbackData) async {
    await FirebaseFirestore.instance
        .collection("feedbacks")
        .add({"userId": currentUser.id, "feedbackData": feedbackData});
  }

  static getRecipe(String id, UserModel currentUser) async {
    var data = await FirebaseFirestore.instance
        .collection("recipes")
        .where("id", isEqualTo: id)
        .get();
    if (data.docs.isEmpty) {
      return null;
    }
    var myRecipes = data.docs.map((item) {
      var isLiked = false, isFavorite = false;

      if (currentUser.id != "" && currentUser.recipeLikes.contains(item.id)) {
        isLiked = true;
      }
      if (LocalVariables.idsListRecipes.contains(item.id)) {
        isFavorite = true;
      }
      return Recipe.fromJson(
        item.data(),
        item.id,
        isLiked: isLiked,
        isFavorite: isFavorite,
      );
    }).toList();
    return myRecipes.first;
  }

  static updateRecipeViews(Recipe recipe) async {
    try {
      var recipeData = await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipe.id)
          .get();
      var rec = Recipe.fromJson(recipeData.data()!, recipeData.data()!["id"]);
      rec.views += 1;
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipe.id)
          .update(rec.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static loadIngredientsRevisionByUser(UserModel currentUser) async {
    var data = await FirebaseFirestore.instance
        .collection("revisionsIngredients")
        .where("userId", isEqualTo: currentUser.id)
        .get();
    return data.docs.map((e) => Ingredient.fromJson(e.data(), e.id)).toList();
  }

  static loadMeasureRevisionByUser(UserModel currentUser) async {
    var data = await FirebaseFirestore.instance
        .collection("revisionsMeasure")
        .where("userId", isEqualTo: currentUser.id)
        .get();
    return data.docs.map((e) => Measure.fromJson(e.data())).toList();
  }

  static loadCategorieRevisionByUser(UserModel currentUser) async {
    var data = await FirebaseFirestore.instance
        .collection("revisionsCategories")
        .where("userId", isEqualTo: currentUser.id)
        .get();
    return data.docs.map((e) => Categorie.fromJson(e.data())).toList();
  }

  static getCategoriesRevision() async {
    var data = await FirebaseFirestore.instance
        .collection("revisionsCategories")
        .get();
    return data.docs.map((e) => Categorie.fromJson(e.data())).toList();
  }

  static getIngredientsRevision() async {
    var data = await FirebaseFirestore.instance
        .collection("revisionsIngredients")
        .get();
    return data.docs.map((e) => Ingredient.fromJson(e.data(), e.id)).toList();
  }

  static getMeasuresRevision() async {
    var data =
        await FirebaseFirestore.instance.collection("revisionsMeasure").get();
    var x = data.docs.map((e) => Measure.fromJson(e.data())).toList();
    return x;
  }

  static verifySimilarIngredient(Ingredient ingredient) async {
    var data = await FirebaseFirestore.instance
        .collection("ingredients")
        .where("name", isEqualTo: ingredient.name)
        .get();
    if (data.docs.isEmpty) {
      data = await FirebaseFirestore.instance
          .collection("ingredients")
          .where("plural", isEqualTo: ingredient.plurals)
          .get();
      if (data.docs.isEmpty) {
        return null;
      }
    }

    return data.docs
        .map((e) => Ingredient.fromJson(e.data(), e.id))
        .toList()
        .first;
  }

  static verifySimilarMeasure(Measure measure) async {
    var data = await FirebaseFirestore.instance
        .collection("measures")
        .where("name", isEqualTo: measure.name)
        .get();
    if (data.docs.isEmpty) {
      data = await FirebaseFirestore.instance
          .collection("measures")
          .where("plural", isEqualTo: measure.plural)
          .get();
      if (data.docs.isEmpty) {
        return null;
      }
    }

    return data.docs.map((e) => Measure.fromJson(e.data())).toList().first;
  }

  static verifySimilarCategorie(Categorie categorie) async {
    var data = await FirebaseFirestore.instance
        .collection("categories")
        .where("name", isEqualTo: categorie.name)
        .get();
    if (data.docs.isEmpty) {
      return null;
    }

    return data.docs.map((e) => Categorie.fromJson(e.data())).toList().first;
  }

  static updateIngredient(Ingredient ingredient,
      {bool rejectIngredient = false}) async {
    var db = FirebaseFirestore.instance;
    try {
      await checkConnectivityStatus();
      var data = await db.collection("revisionRecipes").get();
      var myRecipes = data.docs.map((item) {
        var isLiked = false, isFavorite = false;
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }
        return Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        );
      }).toList();
      var batch = db.batch();
      var count = 0;

      myRecipes = myRecipes.where((element) {
        return element.ingredientsRevision
            .where((element) =>
                element.name == ingredient.name &&
                element.plurals == ingredient.plurals)
            .isNotEmpty;
      }).toList();

      var result = await db
          .collection("revisionsIngredients")
          .where("name", isEqualTo: ingredient.name)
          .where("plural", isEqualTo: ingredient.plurals)
          .get();
      await db
          .collection("revisionsIngredients")
          .doc(result.docs.first.id)
          .delete();

      for (var rec in myRecipes) {
        if (count == 500) {
          batch.commit();

          batch = db.batch();
          count = 0;
        }
        var ingredientDeleted = rec.ingredientsRevision.removeAt(
            rec.ingredientsRevision.indexWhere((element) =>
                element.name == ingredient.name &&
                element.plurals == ingredient.plurals));
        if (rejectIngredient) {
          rec.ingredientsRevisionError.add(ingredientDeleted);
        } else {
          await FirebaseFirestore.instance
              .collection("ingredients")
              .doc(ingredientDeleted.id)
              .set(ingredientDeleted.toJson());
        }

        var ref = db.collection("revisionRecipes").doc(rec.id);

        if (rec.categoriesRevision.isEmpty &&
            rec.ingredientsRevision.isEmpty &&
            rec.measuresRevision.isEmpty) {
          var resultUser = await FirebaseFirestore.instance
              .collection("users")
              .where("id", isEqualTo: rec.userInfo!.idUser)
              .get();
          var user = UserModel.fromJson(resultUser.docs.first.data());
          if (rec.measuresRevisionError.isEmpty &&
              rec.ingredientsRevisionError.isEmpty &&
              rec.categoriesRevisionError.isEmpty) {
            rec.statusRecipe = StatusRevisionRecipe.Checked;
            await moveRevisionRecipeToConfirmed(rec);
            sendPushMessage(
                "A receita ${rec.title} foi aceita com sucesso!! Ela já está disponivel para ser acessada.",
                "Atualização da Receita ${rec.title}",
                user.deviceToken);
          } else {
            String errorIngredients = "";
            String errorMeasure = "";
            String errorCategorie = "";
            if (rec.ingredientsRevisionError.isNotEmpty) {
              errorIngredients =
                  "Ingrediente(s): ${rec.ingredientsRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            if (rec.measuresRevisionError.isNotEmpty) {
              errorMeasure =
                  "Medida(s): ${rec.measuresRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            if (rec.categoriesRevisionError.isNotEmpty) {
              errorCategorie =
                  "Categorias(s): ${rec.categoriesRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            sendPushMessage(
                "A receita ${rec.title} foi recusada.\nOcorreu erro nos seguintes dados:\n$errorIngredients $errorMeasure $errorCategorie",
                "Atualização da Receita ${rec.title}",
                user.deviceToken);
            rec.statusRecipe = StatusRevisionRecipe.Error;
            batch.update(ref, rec.toJson());
            count += 1;
          }
        } else {
          batch.update(ref, rec.toJson());
          count += 1;
        }
      }
      if (count != 0) {
        batch.commit();
      }

      return true;
    } catch (e, stack) {
      print(stack);
      return false;
    }
  }

  static updateMeasure(Measure measure, {bool rejectMeasure = false}) async {
    var db = FirebaseFirestore.instance;
    try {
      await checkConnectivityStatus();
      var data = await db.collection("revisionRecipes").get();
      var myRecipes = data.docs.map((item) {
        var isLiked = false, isFavorite = false;
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }
        return Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        );
      }).toList();
      var batch = db.batch();
      var count = 0;

      myRecipes = myRecipes.where((element) {
        return element.measuresRevision
            .where((element) =>
                element.name == measure.name &&
                element.plural == measure.plural)
            .isNotEmpty;
      }).toList();

      var result = await db
          .collection("revisionsMeasure")
          .where("name", isEqualTo: measure.name)
          .where("plural", isEqualTo: measure.plural)
          .get();
      await db
          .collection("revisionsMeasure")
          .doc(result.docs.first.id)
          .delete();

      for (var rec in myRecipes) {
        if (count == 500) {
          batch.commit();

          batch = db.batch();
          count = 0;
        }
        var measureDeleted = rec.measuresRevision.removeAt(rec.measuresRevision
            .indexWhere((element) =>
                element.name == measure.name &&
                element.plural == measure.plural));
        if (rejectMeasure) {
          rec.measuresRevisionError.add(measureDeleted);
        } else {
          await FirebaseFirestore.instance
              .collection("measures")
              .add(measureDeleted.toJson());
        }

        var ref = db.collection("revisionRecipes").doc(rec.id);

        if (rec.categoriesRevision.isEmpty &&
            rec.ingredientsRevision.isEmpty &&
            rec.measuresRevision.isEmpty) {
          var resultUser = await FirebaseFirestore.instance
              .collection("users")
              .where("id", isEqualTo: rec.userInfo!.idUser)
              .get();
          var user = UserModel.fromJson(resultUser.docs.first.data());
          if (rec.measuresRevisionError.isEmpty &&
              rec.ingredientsRevisionError.isEmpty &&
              rec.categoriesRevisionError.isEmpty) {
            rec.statusRecipe = StatusRevisionRecipe.Checked;
            await moveRevisionRecipeToConfirmed(rec);
            sendPushMessage(
                "A receita ${rec.title} foi aceita com sucesso!! Ela já está disponivel para ser acessada.",
                "Atualização da Receita ${rec.title}",
                user.deviceToken);
          } else {
            String errorIngredients = "";
            String errorMeasure = "";
            String errorCategorie = "";
            if (rec.ingredientsRevisionError.isNotEmpty) {
              errorIngredients =
                  "Ingrediente(s): ${rec.ingredientsRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            if (rec.measuresRevisionError.isNotEmpty) {
              errorMeasure =
                  "Medida(s): ${rec.measuresRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            if (rec.categoriesRevisionError.isNotEmpty) {
              errorCategorie =
                  "Categorias(s): ${rec.categoriesRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            sendPushMessage(
                "A receita ${rec.title} foi recusada.\nOcorreu erro nos seguintes dados:\n$errorIngredients $errorMeasure $errorCategorie",
                "Atualização da Receita ${rec.title}",
                user.deviceToken);
            rec.statusRecipe = StatusRevisionRecipe.Error;
            batch.update(ref, rec.toJson());
            count += 1;
          }
        } else {
          batch.update(ref, rec.toJson());
          count += 1;
        }
      }
      if (count != 0) {
        batch.commit();
      }

      return true;
    } catch (e, stack) {
      print(stack);
      return false;
    }
  }

  static updateCategorie(Categorie categorie,
      {bool rejectCategorie = false}) async {
    var db = FirebaseFirestore.instance;
    try {
      await checkConnectivityStatus();
      var data = await db.collection("revisionRecipes").get();
      var myRecipes = data.docs.map((item) {
        var isLiked = false, isFavorite = false;
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          isFavorite = true;
        }
        return Recipe.fromJson(
          item.data(),
          item.id,
          isLiked: isLiked,
          isFavorite: isFavorite,
        );
      }).toList();
      var batch = db.batch();
      var count = 0;

      myRecipes = myRecipes.where((element) {
        return element.categoriesRevision
            .where((element) => element.name == categorie.name)
            .isNotEmpty;
      }).toList();

      var result = await db
          .collection("revisionsCategories")
          .where("name", isEqualTo: categorie.name)
          .get();
      await db
          .collection("revisionsCategories")
          .doc(result.docs.first.id)
          .delete();

      for (var rec in myRecipes) {
        if (count == 500) {
          batch.commit();

          batch = db.batch();
          count = 0;
        }
        var categorieDeleted = rec.categoriesRevision.removeAt(rec
            .categoriesRevision
            .indexWhere((element) => element.name == categorie.name));
        if (rejectCategorie) {
          rec.categoriesRevisionError.add(categorieDeleted);
        } else {
          await FirebaseFirestore.instance
              .collection("categories")
              .add(categorieDeleted.toJson());
        }

        var ref = db.collection("revisionRecipes").doc(rec.id);

        if (rec.categoriesRevision.isEmpty &&
            rec.ingredientsRevision.isEmpty &&
            rec.measuresRevision.isEmpty) {
          var resultUser = await FirebaseFirestore.instance
              .collection("users")
              .where("id", isEqualTo: rec.userInfo!.idUser)
              .get();
          var user = UserModel.fromJson(resultUser.docs.first.data());
          if (rec.measuresRevisionError.isEmpty &&
              rec.ingredientsRevisionError.isEmpty &&
              rec.categoriesRevisionError.isEmpty) {
            rec.statusRecipe = StatusRevisionRecipe.Checked;
            await moveRevisionRecipeToConfirmed(rec);
            sendPushMessage(
                "A receita ${rec.title} foi aceita com sucesso!! Ela já está disponivel para ser acessada.",
                "Atualização da Receita ${rec.title}",
                user.deviceToken);
          } else {
            String errorIngredients = "";
            String errorMeasure = "";
            String errorCategorie = "";
            if (rec.ingredientsRevisionError.isNotEmpty) {
              errorIngredients =
                  "Ingrediente(s): ${rec.ingredientsRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            if (rec.measuresRevisionError.isNotEmpty) {
              errorMeasure =
                  "Medida(s): ${rec.measuresRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            if (rec.categoriesRevisionError.isNotEmpty) {
              errorCategorie =
                  "Categorias(s): ${rec.categoriesRevisionError.map((e) => e.name).toList().join(", ")}\n";
            }
            sendPushMessage(
                "A receita ${rec.title} foi recusada.\nOcorreu erro nos seguintes dados:\n$errorIngredients $errorMeasure $errorCategorie",
                "Atualização da Receita ${rec.title}",
                user.deviceToken);
            rec.statusRecipe = StatusRevisionRecipe.Error;
            batch.update(ref, rec.toJson());
            count += 1;
          }
        } else {
          batch.update(ref, rec.toJson());
          count += 1;
        }
      }
      if (count != 0) {
        batch.commit();
      }

      return true;
    } catch (e, stack) {
      print(stack);
      return false;
    }
  }

  /*AUX*/
  static moveRevisionRecipeToConfirmed(Recipe recipe) async {
    var result = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: recipe.userInfo!.idUser)
        .get();
    print(result.docs);
    var user = UserModel.fromJson(result.docs.first.data());

    var idToDelete = recipe.id;
    DocumentReference ref =
        FirebaseFirestore.instance.collection("recipes").doc();
    recipe.id = ref.id;

    var urlOld = await FirebaseStorage.instance
        .ref("users/${user.idFirestore}")
        .child("background_${idToDelete}_revision")
        .getDownloadURL();
    final http.Response responseData = await http.get(Uri.parse(urlOld));
    await FirebaseStorage.instance
        .ref("users/${user.idFirestore}")
        .child("background_${recipe.id}")
        .putData(responseData.bodyBytes);
    recipe.imageUrl = await FirebaseStorage.instance
        .ref("users/${user.idFirestore}")
        .child("background_${recipe.id}")
        .getDownloadURL();

    recipe.statusRecipe = StatusRevisionRecipe.Checked;
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipe.id)
        .set(recipe.toJson());
    await FirebaseStorage.instance
        .ref("users/${user.idFirestore}")
        .child("background_${idToDelete}_revision")
        .delete();
    await FirebaseFirestore.instance
        .collection("revisionRecipes")
        .doc(idToDelete)
        .delete();

    user.recipeList[
            user.recipeList.indexWhere((element) => element.id == idToDelete)] =
        RecipeUser(
            id: recipe.id,
            isRevision: recipe.statusRecipe == StatusRevisionRecipe.Checked
                ? false
                : true);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(result.docs[0].reference.id)
        .update(UserModel.toMap(user));
  }

  static void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAC2GbDwE:APA91bFQworYsJmGJOt0pK6rOeJdycpSvAjoNUWRLryQM5E4npNUnWV7a6ymUJekvIVb0XBOvMwPpjooDMaiflfksXYkzRBK3YH9stvjZKQtic-ULjlN2OrcqDN18OcCphr_Oh1Tkmz8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
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

  static Set<T> listContainsMissingOne<T>(List<T> a, List<T> b) {
    final setA = Set.of(a);
    final setB = Set.of(b);
    return setB.difference(setA);
  }

  static checkConnectivityStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw "no_connection";
    }
  }

  static getListByType(ListType type) {
    switch (type) {
      case ListType.RecipePage:
        return listRecipes!;
      case ListType.RecipePageFiltered:
        return listFiltered!;
      case ListType.CategoryPage:
        return listRecipeCategory!;
      case ListType.RecipeResultMatched:
        return listRecipeResult![0];
      case ListType.RecipeResultMissingOne:
        return listRecipeResult![1];
      case ListType.RecipeUser:
        return listRecipeUser;
    }
  }
}
