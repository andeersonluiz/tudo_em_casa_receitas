import 'package:get/get.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'dart:async';

class IngredientController extends GetxController {
  final _firebaseBaseHelper = FirebaseBaseHelper();

  RxList<Ingredient> listIngredients =
      List.filled(1, Ingredient(isSelected: false, searchValue: "", order: 0))
          .obs;
  //ADICIONAR ESSA VARIAVEL EM MEMÓRIA...
  var listIngredientsFiltred = [].obs;
  var filteredSearch = [].obs;
  Rx<bool> isSearching = false.obs;
  Timer? _debounce;
  var keyboardVisible = false.obs;
  @override
  void onInit() async {
    super.onInit();
    listIngredients.assignAll(await getIngredients());
  }

  getIngredients() async {
    return await _firebaseBaseHelper.getIngredients();
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

  filterSearch(String value) {
    isSearching.value = true;

    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      List<Ingredient> res = listIngredients.where((element) {
        if (removeDiacritics(element.searchValue.toLowerCase())
            .contains(removeDiacritics(value.toLowerCase()))) {
          return true;
        } else {
          return false;
        }
      }).toList();
      res.sort((a, b) {
        return (b.searchValue.similarityTo(value))
            .compareTo(value.similarityTo(a.searchValue));
      });
      filteredSearch.assignAll(res);
      isSearching.value = false;
    });
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
}
