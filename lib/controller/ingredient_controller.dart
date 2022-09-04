import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';

import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';

class IngredientController extends GetxController {
  final _firebaseBaseHelper = FirebaseBaseHelper();

  var listIngredients = [].obs;
  var listIngredientsFiltred = [].obs;
  var isLoadingIngredients = false.obs;
  var hasErrorIngredients = false.obs;
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
    listIngredients.assignAll(await getIngredients());
  }
/*
  getIngredients(int limit, {bool loadMore = false}) async {
    if (!hasNext || isFetching.value) return;
    isFetching.value = true;
    var result = [];
    if (!loadMore) {
      result =
          await _firebaseBaseHelper.getIngredients(limit, startAfter: null);
    } else {
      print("carregando mais");
      result = await _firebaseBaseHelper.getIngredients(limit,
          startAfter: startAfter);
    }

    if (result[1] == null) {
      hasErrorIngredients = true;
      return [];
    }
    if (result[1].length < limit) {
      hasNext = false;
    }
    listIngredients.addAll(result[1]);
    startAfter = result[0];
    isFetching.value = false;
    return result[1];
  }
*/

  getIngredients() async {
    isLoadingIngredients.value = true;
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      hasErrorIngredients.value = true;
      return [];
    }
    isLoadingIngredients.value = false;
    return result;
  }

  addIngredientPantry(Ingredient ingredient) async {
    ingredient.isPantry = true;

    listIngredients[listIngredients
        .indexWhere((element) => element.id == ingredient.id)] = ingredient;
    listIngredients.refresh();

    listIngredientsPantry.add(ingredient);
    sortListIngredientPantry(isHome: false, refresh: true);

    await Preferences.addIngredientPantry(ingredient);
    print("b2");
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
    print("filtrando $value");
    var filetred = listIngredients
        .where((ingredient) =>
            ingredient.name.toLowerCase().contains(value.toLowerCase()) ||
            ingredient.plurals.toLowerCase().contains(value.toLowerCase()))
        .toList();
    filetred.sort((a, b) {
      return (b.name.toString().similarityTo(value))
          .compareTo(value.similarityTo(a.name));
    });
    if (isHome) {
      print("ISHOME");
      filetred.sort((a, b) {
        int cmp = (b.isHome.toString()).compareTo((a.isHome.toString()));
        if (cmp != 0) return cmp;
        return a.name.toString().compareTo(b.name.toString());
      });
    } else {
      print("NAO");
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

  /*filterSearch(String value) {
    isSearching.value = true;

    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      var res = listIngredients.where((element) {
        if (removeDiacritics(element.name.toLowerCase())
            .contains(removeDiacritics(value.toLowerCase()))) {
          return true;
        } else {
          return false;
        }
      }).toList();
      res.sort((a, b) {
        return (b.name.similarityTo(value))
            .compareTo(value.similarityTo(a.name));
      });
      filteredSearch.assignAll(res);
      isSearching.value = false;
    });
  }*/

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
