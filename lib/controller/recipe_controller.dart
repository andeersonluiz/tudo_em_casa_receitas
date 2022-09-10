// ignore_for_file: file_names, constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tuple/tuple.dart';

enum StatusRecipe { None, Loading, Finished, Error }

enum StatusHomePage { None, Loading, Finished, Error }

class RecipeResultController extends GetxController {
  var listRecipes = [].obs;
  var listRecipesHomePage = [].obs;
  var listRecipesPantryPage = [].obs;
  var statusRecipesHome = StatusHomePage.None.obs;
  var statusRecipesPage = StatusRecipe.None.obs;
  var textValue = "".obs;
  var listRecipesFiltered = [].obs;
  var query = "";
  var hasEndedLoad = false;
  var cooldownHomeView = DateTime.now();
  var cooldownPantryView = DateTime.now();
  var delayValue = const Duration(seconds: 60);
  var listFilters = [].obs;
  var listFiltersModal = [].obs;
  var initialDataFilter = "";
  var selectedTupleString = "";
  Rx<Tuple3<dynamic, dynamic, dynamic>> tupleSelected =
      Tuple3.fromList(["test", "test", "test"]).obs;
  var filterSelected = "".obs;
  Tuple3? tagValue;
  Tuple3? moreFiltersValue;
  @override
  void onInit() async {
    super.onInit();
    listFilters.assignAll(LocalVariables.filters);
    filterSelected.value = listFilters[0].item1;
    tagValue = listFilters[0];
    await getRecipesHomeView();
  }

  getRecipesHomeView() async {
    var cooldownActual = DateTime.now();
    if (cooldownActual.difference(cooldownHomeView) < delayValue &&
        listRecipesHomePage.isNotEmpty) {
      cooldownHomeView = cooldownActual;
      return;
    }

    cooldownHomeView = cooldownActual;
    statusRecipesHome.value = StatusHomePage.Loading;
    List<String> tags = [
      "",
      "CUPCAKE",
      "PIZZA",
      "BRIGADEIRO"
    ]; //Viriam do LocalVariables
    try {
      listRecipesHomePage
          .assignAll(await FirebaseBaseHelper.getRecipesByTag(tags));
      statusRecipesHome.value = StatusHomePage.Finished;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      statusRecipesHome.value = StatusHomePage.Error;
    }
  }

  getRecipesPantryView() async {
    var cooldownActual = DateTime.now();
    if (cooldownActual.difference(cooldownPantryView) < delayValue &&
        listRecipesPantryPage.isNotEmpty) {
      cooldownPantryView = cooldownActual;
      return;
    }
    cooldownPantryView = cooldownActual;
    statusRecipesHome.value = StatusHomePage.Loading;
    List<String> tags = [
      "",
      "CUPCAKE",
      "PIZZA",
      "BRIGADEIRO"
    ]; //Viriam do LocalVariables
    try {
      listRecipesPantryPage.assignAll(
          await FirebaseBaseHelper.getRecipesByTagAndIngredients(
              LocalVariables.ingredientsPantry +
                  LocalVariables.ingredientsHomePantry,
              tags));
      statusRecipesHome.value = StatusHomePage.Finished;
    } catch (e) {
      statusRecipesHome.value = StatusHomePage.Error;
    }
  }

  getAllRecipes() async {
    hasEndedLoad = false;
    statusRecipesPage.value = StatusRecipe.Loading;
    try {
      var listResult = await FirebaseBaseHelper.getRecipes(tagValue!);
      listRecipes.assignAll(listResult);
      statusRecipesPage.value = StatusRecipe.Finished;
    } catch (e) {
      statusRecipesPage.value = StatusRecipe.Error;
    }
  }

  filterSearch() async {
    hasEndedLoad = false;
    statusRecipesPage.value = StatusRecipe.Loading;
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final results = await FirebaseBaseHelper.filterSearch(
          tagValue!, textValue.value,
          moreFilters:
              tupleSelected.value.item1 == "test" ? null : tupleSelected.value);
      query = textValue.value;
      listRecipesFiltered.assignAll(results);
      statusRecipesPage.value = StatusRecipe.Finished;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      statusRecipesPage.value = StatusRecipe.Error;
    }
  }

  filterResults({bool isFilter = true}) async {
    hasEndedLoad = false;
    statusRecipesPage.value = StatusRecipe.Loading;
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final results = await FirebaseBaseHelper.filterResults(tagValue!,
          moreFilters:
              tupleSelected.value.item1 == "test" ? null : tupleSelected.value,
          isFilter: isFilter);
      query = textValue.value;
      if (isFilter) {
        listRecipesFiltered.assignAll(results);
        listRecipesFiltered.refresh();
      } else {
        listRecipes.assignAll(results);
        listRecipes.refresh();
      }

      statusRecipesPage.value = StatusRecipe.Finished;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      statusRecipesPage.value = StatusRecipe.Error;
    }
  }

  assingListModal(List<Tuple3> itens) {
    initialDataFilter = itens[0].item3;

    listFiltersModal.assignAll(itens);
  }

  updateValueListTimePreparation(Tuple3 tuple) {
    tupleSelected.value = tuple;
  }

  resetValueTuple() {
    tupleSelected.value = Tuple3.fromList(["test", "test", "test"]);
  }

  verifyIfItemSelected() {
    if (tupleSelected.value.item1 != "test") {
      return true;
    }
    return false;
  }

  resetListModal() {
    int index = listFilters.indexWhere((element) => element.item1
        .startsWith(initialDataFilter)); //NAO COLOCAR SUBSTRINGS NA PESQUISA
    listFilters[index] = Tuple3(
        initialDataFilter, listFilters[index].item2, listFilters[index].item3);
    initialDataFilter = "";
    listFiltersModal.clear();
    selectedTupleString = "";
    //listRecipesFiltered.clear();
  }

  sortListFilter() {
    for (var value in listFilters) {
      if (filterSelected.value == value.item1) {
        listFilters.remove(value);
        listFilters.insert(0, value);
      }
    }

    if (selectedTupleString != "") {
      for (var value in listFilters) {
        if (value.item1.toString() == selectedTupleString) {
          listFilters.remove(value);
          listFilters.insert(0, value);
        }
      }
    }
  }

  updateTextValue(String value) {
    textValue.value = value;
  }

  updateFilterSelected(String value) {
    filterSelected.value = value;
  }

  updateTagValue(Tuple3 value) {
    tagValue = value;
  }

  clearListFiltring() {
    listRecipesFiltered.clear();
  }

  updateValueListFilter() {
    Tuple3 tuple = listFiltersModal[0];
    String textToReplace =
        "$initialDataFilter (${tupleSelected.value.item3.toLowerCase()}${tupleSelected.value.item1} ${tuple.item1.toLowerCase()})";
    int index =
        listFilters.indexWhere((element) => tuple.item3 == element.item1);
    listFilters[index] = Tuple3(
        textToReplace, listFilters[index].item2, listFilters[index].item3);
    listFiltersModal[0] = Tuple3(
        listFiltersModal[0].item1, listFiltersModal[0].item2, textToReplace);
    selectedTupleString = textToReplace;
  }
}
