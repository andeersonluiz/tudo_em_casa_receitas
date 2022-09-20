import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';

import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';

import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
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
  static List<Recipe>? listRecipeCategory;
  static List<List<Recipe>>? listRecipeResult;
  static List<String> lastIngredientsName = [];
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
  }

  static getRecipesResults() async {
    List<String> allIngredientsName = (LocalVariables.ingredientsPantry +
            LocalVariables.ingredientsHomePantry)
        .map((e) => e.name)
        .toList();
    if (foundation.listEquals(allIngredientsName, lastIngredientsName)) {
      return listRecipeResult;
    }
    lastIngredientsName = allIngredientsName;
    await checkConnectivityStatus();
    final db = FirebaseFirestore.instance;
    var ref = db.collection("recipes").orderBy("views", descending: true);
    var data = (await ref.get()).docs;
    var map = {"containsAll": <Recipe>[], "MissingOne": <Recipe>[]};
    for (var item in data) {
      if (listContainsAll(
        allIngredientsName,
        List<String>.from(item.data()["values"]),
      )) {
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
        if (LocalVariables.idsListRecipes.contains(item.id)) {
          rec = Recipe.fromJson(
            item.data(),
            item.id,
            isFavorite: true,
            missingIngredient: missingIngredient,
          );
        } else {
          rec = Recipe.fromJson(
            item.data(),
            item.id,
            missingIngredient: missingIngredient,
          );
        }
        map["MissingOne"] = map["MissingOne"]! + [rec];
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

  static getRecipesByTags(List<String> tags) async {
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

  static getRecipesByTag(String tag) async {
    final db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> results;
    await checkConnectivityStatus();
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
    listRecipeCategory = myRecipes;

    return listRecipeCategory;
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
      /*//test
      int count = 0;
      for (Recipe rec in myList) {
        if (rec.values.isEmpty) {
          print(rec.id);
          count += 1;
        }
      }
      print("count $count");
      //test*/
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
      var user = UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          name: name,
          image: urlImage,
          recipeList: [],
          wallpaperImage: wallpaperImage,
          followers: 0,
          following: 0);
      await FirebaseFirestore.instance
          .collection("users")
          .add(UserModel.toMap(user));
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
      return "Erro inesperado. Tente novamente mais tarde";
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
      return "Erro inesperado. Tente novamente mais tarde";
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
      return "Erro inesperado. Tente novamente mais tarde";
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
        var user = UserModel(
            id: FirebaseAuth.instance.currentUser!.uid,
            name: userCredential.user!.displayName!,
            image: urlImage,
            followers: 0,
            recipeList: [],
            wallpaperImage: wallpaperImage,
            following: 0);
        await FirebaseFirestore.instance
            .collection("users")
            .add(UserModel.toMap(user));

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
      return "Erro inesperado. Tente novamente mais tarde";
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
      return "Erro inesperado. Tente novamente mais tarde";
    }
  }

  static logOut() async {
    await FirebaseAuth.instance.signOut();

    //await GoogleSignIn().signOut();
  }

  static getMyRecipes(UserModel currentUser) async {
    if (currentUser.recipeList.isEmpty) {
      return [];
    }
    var results = await FirebaseFirestore.instance
        .collection("recipes")
        .where("id", whereIn: currentUser.recipeList)
        .get();
    var myList = results.docs.map((item) {
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

  /*AUX*/
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
    }
  }
}
