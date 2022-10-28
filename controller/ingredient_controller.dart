// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/categorie_model.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';

import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';

import '../model/measure_model.dart';

enum StatusIngredients { None, Loading, Finished, Error }

class IngredientController extends GetxController {
  final _firebaseBaseHelper = FirebaseBaseHelper();

  var listIngredients = [].obs;
  var listIngredientsFiltred = [].obs;
  var listMeasures = [].obs;
  var listCategories = [].obs;
  var statusIngredients = StatusIngredients.None.obs;

  Rx<String> textValue = "".obs;

  //ADICIONAR ESSA VARIAVEL EM MEMÓRIA...
  var listIngredientsPantry = [].obs;
  var listIngredientsHomePantry = [].obs;
  var filteredSearch = [].obs;
  Rx<bool> isSearching = false.obs;
  var keyboardVisible = false.obs;

  var isFetching = false.obs;
  var hasErrorIngredientsHomePantry = false;
  bool hasNext = true;
  UserController userController = Get.find();

  @override
  void onInit() async {
    super.onInit();
    await initData();
  }

  initData() async {
    print("initData");
    LocalVariables.ingredientsHomePantry
        .sort((a, b) => a.name.compareTo(b.name));
    LocalVariables.ingredientsPantry.sort((a, b) => a.name.compareTo(b.name));
    listIngredientsPantry.assignAll(LocalVariables.ingredientsPantry);
    listIngredientsHomePantry.assignAll(LocalVariables.ingredientsHomePantry);
    await getIngredients();
    await getMeasures();
    await getCategories();
    await loadIngredientsRevision(userController.currentUser.value);
    await loadMeasureRevision(userController.currentUser.value);
    await loadCategoriesvision(userController.currentUser.value);
  }

  getIngredients() async {
    statusIngredients.value = StatusIngredients.Loading;
    dynamic result;
    try {
      result = await _firebaseBaseHelper.getIngredients();
      result = result.map((ingredient) {
        if (LocalVariables.ingredientsPantry
            .any((ing) => ingredient.id == ing.id)) {
          ingredient.isPantry = true;
        } else if (LocalVariables.ingredientsHomePantry
            .any((ing) => ingredient.id == ing.id)) {
          ingredient.isHome = true;
        }

        return ingredient;
      }).toList();
      result.sort((a, b) {
        int cmp = (b.isPantry.toString()).compareTo((a.isPantry.toString()));
        if (cmp != 0) return cmp;
        return a.name.toString().compareTo(b.name.toString());
      });
      statusIngredients.value = StatusIngredients.Finished;
      listIngredients.assignAll(result);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      statusIngredients.value = StatusIngredients.Error;
      return [];
    }
  }

  addIngredient(Ingredient ingredient) {
    listIngredients.add(ingredient);
    listIngredients.sort((a, b) => b.order.compareTo(a.order));
    listIngredients.refresh();
  }

  remove(Ingredient ingredient) {
    listIngredients.remove(ingredient);
  }

  loadIngredientsRevision(UserModel currentUser) async {
    removeRevisions();
    var listIds = listIngredients.map((e) => e.id).toList();
    List<Ingredient> listIngredientsRevised = [];
    List<Ingredient> listIngredientsNotRevised = [];
    var ingredients =
        await FirebaseBaseHelper.loadIngredientsRevisionByUser(currentUser);
    for (var element in ingredients) {
      if (listIds.contains(element.id)) {
        listIngredientsRevised.add(element);
      } else {
        element.order = 5000;
        element.isRevision = true;
        listIngredientsNotRevised.add(element);
      }
    }
    if (listIngredientsRevised.isNotEmpty) {
      FirebaseBaseHelper.deleteIngredientsRevised(listIngredientsRevised);
    }

    if (listIngredientsNotRevised.isNotEmpty) {
      listIngredients.addAll(listIngredientsNotRevised);
    }
    listIngredients.sort((a, b) => b.order.compareTo(a.order));
    listIngredients.refresh();
  }

  removeRevisions() {
    var listFiltred =
        listIngredients.where((p0) => p0.isRevision == false).toList();
    listIngredients.assignAll(listFiltred);
  }

  getMeasures() async {
    listMeasures.assignAll(await FirebaseBaseHelper.getMeasures());
  }

  addtMeasure(Measure measure) {
    listMeasures.add(measure);
    listMeasures.sort((a, b) => b.order.compareTo(a.order));
    listMeasures.refresh();
  }

  removeMeasure(Measure measure) {
    listMeasures.remove(measure);
  }

  loadMeasureRevision(UserModel currentUser) async {
    removeMeasuresRevisions();
    var listNames = listMeasures
        .map((e) => e.name.toString().toLowerCase().trim())
        .toList();
    List<Measure> listMeasuresRevised = [];
    List<Measure> listMeasuresNotRevised = [];
    var measures =
        await FirebaseBaseHelper.loadMeasureRevisionByUser(currentUser);
    for (var element in measures) {
      if (listNames.contains(element.name.toLowerCase().trim())) {
        listMeasuresRevised.add(element);
      } else {
        element.order = 5000;
        element.isRevision = true;
        listMeasuresNotRevised.add(element);
      }
    }
    if (listMeasuresRevised.isNotEmpty) {
      FirebaseBaseHelper.deleteMeasureRevised(listMeasuresRevised);
    }

    if (listMeasuresNotRevised.isNotEmpty) {
      listMeasures.addAll(listMeasuresNotRevised);
    }
    listMeasures.sort((a, b) => b.order.compareTo(a.order));
    listMeasures.refresh();
  }

  removeMeasuresRevisions() {
    var listFiltred =
        listMeasures.where((p0) => p0.isRevision == false).toList();
    listMeasures.assignAll(listFiltred);
  }

  getCategories() async {
    listCategories.assignAll(await FirebaseBaseHelper.getCategories());
  }

  addtCategorie(Categorie categorie) {
    listCategories.add(categorie);
    listCategories.sort((a, b) => b.order.compareTo(a.order));
    listCategories.refresh();
  }

  removeCategorie(Categorie categorie) {
    listCategories.remove(categorie);
  }

  loadCategoriesvision(UserModel currentUser) async {
    removeCategoriesRevisions();
    var listNames = listCategories
        .map((e) => e.name.toString().toLowerCase().trim())
        .toList();
    List<Categorie> listCategoriesRevised = [];
    List<Categorie> listCategoriesNotRevised = [];
    var categories =
        await FirebaseBaseHelper.loadCategorieRevisionByUser(currentUser);
    for (var element in categories) {
      if (listNames.contains(element.name.toLowerCase().trim())) {
        listCategories.add(element);
      } else {
        element.order = 5000;
        element.isRevision = true;
        listCategoriesNotRevised.add(element);
      }
    }
    if (listCategoriesRevised.isNotEmpty) {
      FirebaseBaseHelper.deleteCategorieRevised(listCategoriesRevised);
    }

    if (listCategoriesNotRevised.isNotEmpty) {
      listCategories.addAll(listCategoriesNotRevised);
    }
    listCategories.sort((a, b) => b.order.compareTo(a.order));
    listCategories.refresh();
  }

  removeCategoriesRevisions() {
    var listFiltred =
        listCategories.where((p0) => p0.isRevision == false).toList();
    listCategories.assignAll(listFiltred);
  }

  addIngredientPantry(Ingredient ingredient) async {
    ingredient.isPantry = true;
    listIngredients[listIngredients
        .indexWhere((element) => element.id == ingredient.id)] = ingredient;
    listIngredients.refresh();
    listIngredientsPantry.add(ingredient);
    sortListIngredientPantry(isHome: false, refresh: true);
    await Preferences.addIngredientPantry(ingredient);
  }

  removeIngredientPantry(Ingredient ingredient, {isHome = false}) async {
    ingredient.isPantry = false;
    listIngredients[listIngredients
        .indexWhere((element) => element.id == ingredient.id)] = ingredient;

    if (!isHome) {
      sortListIngredient();
      listIngredients.refresh();
    }

    listIngredientsPantry.removeWhere((ing) => ingredient.id == ing.id);
    listIngredientsPantry.refresh();
    await Preferences.removeIngredientPantry(ingredient);
  }

  filterSearch(String value, {bool isHome = false}) {
    var filetred = listIngredients
        .where((ingredient) =>
            removeDiacritics(ingredient.name.toLowerCase())
                .contains(removeDiacritics(value.toLowerCase())) ||
            removeDiacritics(ingredient.plurals.toLowerCase())
                .contains(removeDiacritics(value.toLowerCase())))
        .toList();
    filetred.sort((a, b) {
      return (b.name.toString().similarityTo(value))
          .compareTo(value.similarityTo(a.name));
    });
    if (isHome) {
      filetred.sort((a, b) {
        int cmp = (b.isHome.toString()).compareTo((a.isHome.toString()));
        if (cmp != 0) return cmp;
        return a.name.toString().compareTo(b.name.toString());
      });
    } else {
      filetred.sort((a, b) {
        int cmp = (b.isPantry.toString()).compareTo((a.isPantry.toString()));
        if (cmp != 0) return cmp;
        return a.name.toString().compareTo(b.name.toString());
      });
    }

    listIngredientsFiltred.assignAll(filetred);
  }

  clearListFiltring() {
    listIngredientsFiltred.clear();
  }

  updateTextValue(String value) {
    textValue.value = value;
  }

  addIngredientHomePantry(Ingredient ingredient) async {
    ingredient.isHome = true;
    ingredient.isPantry = false;
    listIngredients[listIngredients
        .indexWhere((element) => element.id == ingredient.id)] = ingredient;
    listIngredients.refresh();

    if (listIngredientsPantry.any((element) => element.id == ingredient.id)) {
      removeIngredientPantry(ingredient, isHome: true);
      await Preferences.removeIngredientPantry(ingredient);
      listIngredientsPantry.refresh();
    }
    listIngredientsHomePantry.add(ingredient);
    sortListIngredientPantry(isHome: true, refresh: true);

    await Preferences.addIngredientHomePantry(ingredient);
  }

  removeIngredientHomePantry(Ingredient ingredient) async {
    ingredient.isHome = false;
    listIngredients[listIngredients
        .indexWhere((element) => element.id == ingredient.id)] = ingredient;
    sortListIngredient(isHome: true);
    listIngredients.refresh();

    listIngredientsHomePantry.removeWhere((ing) => ingredient.id == ing.id);
    listIngredientsHomePantry.refresh();
    await Preferences.removeIngredientHomePantry(ingredient);
  }

  verifyMinIngredients() {
    if ((listIngredientsPantry.length + listIngredientsHomePantry.length) >
        LocalVariables.minIngredients) {
      return true;
    }
    return false;
  }

  updateIsSelected(ingredient) {
    int index = listIngredients.indexOf(ingredient);
    listIngredients.removeAt(index);
    ingredient.isSelected = !ingredient.isSelected;
    if (!ingredient.isSelected) {
      ingredient.order = 0;
    } else {
      listIngredients.sort((a, b) => b.order.compareTo(a.order));
      ingredient.order = listIngredients[0].order + 1;
    }

    listIngredients.add(ingredient);
    listIngredients.sort((a, b) => b.order.compareTo(a.order));
  }

  getListIngredientsFiltred() {
    return listIngredients.where((item) => item.isSelected == true);
  }

  clearSearch() {
    filteredSearch.assignAll([]);
  }

  clearListFiltred() {
    List<Ingredient> temp = [];
    for (var item in listIngredients) {
      item.isSelected = false;
      temp.add(item);
    }
    listIngredients.assignAll(temp);
  }

  setKeyboardVisible(bool value) {
    keyboardVisible.value = value;
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

  sortListIngredient({bool refresh = false, bool isHome = false}) {
    if (isHome) {
      listIngredients.sort((a, b) {
        int cmp = (b.isHome.toString()).compareTo((a.isHome.toString()));
        if (cmp != 0) return cmp;
        return a.name.toString().compareTo(b.name.toString());
      });
    } else {
      listIngredients.sort((a, b) {
        int cmp = (b.isPantry.toString()).compareTo((a.isPantry.toString()));
        if (cmp != 0) return cmp;
        return a.name.toString().compareTo(b.name.toString());
      });
    }

    if (refresh) {
      listIngredients.refresh();
    }
  }

  sortListIngredientPantry({bool refresh = false, bool isHome = false}) {
    if (!isHome) {
      listIngredientsPantry.sort((a, b) {
        return a.name.toString().compareTo(b.name.toString());
      });
      listIngredientsPantry.refresh();
    } else {
      listIngredientsHomePantry.sort((a, b) {
        return a.name.toString().compareTo(b.name.toString());
      });
      listIngredientsHomePantry.refresh();
    }
  }
}
