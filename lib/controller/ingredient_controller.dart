// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';

import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';

enum StatusIngredients { None, Loading, Finished, Error }

class IngredientController extends GetxController {
  final _firebaseBaseHelper = FirebaseBaseHelper();

  var listIngredients = [].obs;
  var listIngredientsFiltred = [].obs;
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
  @override
  void onInit() async {
    super.onInit();
    LocalVariables.ingredientsHomePantry
        .sort((a, b) => a.name.compareTo(b.name));
    LocalVariables.ingredientsPantry.sort((a, b) => a.name.compareTo(b.name));
    listIngredientsPantry.assignAll(LocalVariables.ingredientsPantry);
    listIngredientsHomePantry.assignAll(LocalVariables.ingredientsHomePantry);
    await getIngredients();
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
