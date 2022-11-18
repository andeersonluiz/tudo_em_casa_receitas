// ignore_for_file: file_names, constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tuple/tuple.dart';

enum StatusRecipe { None, Loading, Finished, Error }

enum StatusRecipeCategory { None, Loading, Finished, Error }

enum StatusHomePage { None, Loading, Finished, Error }

enum StatusRecipeResult { None, Loading, Finished, Error }

enum ListType {
  RecipePage,
  RecipePageFiltered,
  CategoryPage,
  RecipeResultMatched,
  RecipeResultMissingOne,
  RecipeUser
}

class RecipeResultController extends GetxController {
  var listRecipes = [].obs;
  var listRecipesHomePage = [].obs;
  var listRecipesPantryPage = [].obs;
  var listRecipesCategory = [].obs;
  var listRecipesResult = [].obs;
  var listRecipesResultMatched = [].obs;
  var listRecipesResultMissingOne = [].obs;
  var listRecipesUser = [].obs;

  var statusRecipesHome = StatusHomePage.None.obs;
  var statusRecipesPage = StatusRecipe.None.obs;
  var statusRecipesCategory = StatusRecipeCategory.None.obs;
  var statusRecipesResult = StatusRecipeResult.None.obs;
  var textValue = "".obs;
  var listRecipesFiltered = [].obs;
  var query = "";
  var cooldownHomeView = DateTime.now();
  var cooldownPantryView = DateTime.now();
  var delayValue = const Duration(seconds: 60);
  var listFilters = [].obs;
  var listFiltersModal = [].obs;
  var initialDataFilter = "";
  var selectedTupleString = "";
  Rx<bool> isLastPage = false.obs;
  Rx<Tuple3<dynamic, dynamic, dynamic>> tupleSelected =
      Tuple3.fromList(["test", "test", "test"]).obs;
  var applyClicked = false;
  Tuple3<dynamic, dynamic, dynamic> tupleTemp =
      Tuple3.fromList(["test", "test", "test"]);
  var filterSelected = "".obs;
  Tuple3? tagValue;
  Tuple3? moreFiltersValue;

  UserController userController = Get.find();
  @override
  void onInit() async {
    super.onInit();
    await initData();
  }

  initData() async {
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

    try {
      listRecipesHomePage.assignAll(await FirebaseBaseHelper.getRecipesByTags(
          [""] + LocalVariables.listCategories.map((e) => e.name).toList(),
          userController.currentUser.value));
      statusRecipesHome.value = StatusHomePage.Finished;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(stacktrace);
      }
      statusRecipesHome.value = StatusHomePage.Error;
    }
  }

  getMoreRecipesHomeView() async {
    try {
      var result = await FirebaseBaseHelper.getMoreRecipesByTags(
          LocalVariables.listCategories.map((e) => e.name).toList(),
          userController.currentUser.value);
      if (result.isEmpty) isLastPage.value = true;
      listRecipesHomePage.addAll(result);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      statusRecipesHome.value = StatusHomePage.Error;
    }
  }
/*
  getRecipesPantryView() async {
    var cooldownActual = DateTime.now();
    if (cooldownActual.difference(cooldownPantryView) < delayValue &&
        listRecipesPantryPage.isNotEmpty) {
      cooldownPantryView = cooldownActual;
      return;
    }
    cooldownPantryView = cooldownActual;
    statusRecipesHome.value = StatusHomePage.Loading;
    try {
      listRecipesPantryPage.assignAll(
          await FirebaseBaseHelper.getRecipesByTagAndIngredients(
              LocalVariables.ingredientsPantry +
                  LocalVariables.ingredientsHomePantry,
              [""] + LocalVariables.listCategories.map((e) => e.name).toList(),
              userController.currentUser.value));
      statusRecipesHome.value = StatusHomePage.Finished;
    } catch (e) {
      statusRecipesHome.value = StatusHomePage.Error;
    }
  }

  getMoreRecipesPantryView() async {
    try {
      listRecipesPantryPage.addAll(
          await FirebaseBaseHelper.getRecipesByTagAndIngredients(
              LocalVariables.ingredientsPantry +
                  LocalVariables.ingredientsHomePantry,
              [""] + LocalVariables.listCategories.map((e) => e.name).toList(),
              userController.currentUser.value));
    } catch (e) {
      statusRecipesHome.value = StatusHomePage.Error;
    }
  }*/

  getRecipeByTag(String tag) async {
    statusRecipesCategory.value = StatusRecipeCategory.Loading;
    try {
      var listResult = await FirebaseBaseHelper.getRecipesByTag(
          tag, userController.currentUser.value);
      listRecipesCategory.assignAll(listResult);
      statusRecipesCategory.value = StatusRecipeCategory.Finished;
    } catch (e) {
      statusRecipesCategory.value = StatusRecipeCategory.Error;
    }
  }

  getRecipesByUser(UserModel user) async {
    statusRecipesResult.value = StatusRecipeResult.Loading;
    await Future.delayed(const Duration(milliseconds: 500));
    var results = await FirebaseBaseHelper.getRecipesFromUser(user);

    listRecipesUser.assignAll(results);
    listRecipesUser.refresh();
    statusRecipesResult.value = StatusRecipeResult.Finished;
  }

  getAllRecipes() async {
    statusRecipesPage.value = StatusRecipe.Loading;
    try {
      var listResult = await FirebaseBaseHelper.getRecipes(
          tagValue!, userController.currentUser.value);
      listRecipes.assignAll(listResult);
      statusRecipesPage.value = StatusRecipe.Finished;
    } catch (e) {
      statusRecipesPage.value = StatusRecipe.Error;
    }
  }

  getRecipesResults() async {
    statusRecipesResult.value = StatusRecipeResult.Loading;
    try {
      var listResult = await FirebaseBaseHelper.getRecipesResults(
          userController.currentUser.value);
      listRecipesResult.assignAll(listResult);
      if (listResult.isEmpty) {
        listRecipesResultMatched.assignAll([]);
        listRecipesResultMissingOne.assignAll([]);
      } else {
        listRecipesResultMatched.assignAll(listResult[0]);
        listRecipesResultMissingOne.assignAll(listResult[1]);
      }

      statusRecipesResult.value = StatusRecipeResult.Finished;
    } catch (e) {
      statusRecipesResult.value = StatusRecipeResult.Error;
    }
  }

  filterSearch() async {
    statusRecipesPage.value = StatusRecipe.Loading;
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final results = await FirebaseBaseHelper.filterSearch(
          tagValue!,
          textValue.value,
          moreFilters:
              tupleSelected.value.item1 == "test" ? null : tupleSelected.value,
          userController.currentUser.value);
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

  getListByType(ListType listType) {
    var results = FirebaseBaseHelper.getListByType(listType);
    switch (listType) {
      case ListType.RecipePage:
        listRecipes.assignAll(results);
        break;
      case ListType.RecipePageFiltered:
        listRecipesFiltered.assignAll(results);
        break;
      case ListType.CategoryPage:
        listRecipesCategory.assignAll(results);
        break;
      case ListType.RecipeResultMatched:
        listRecipesResultMatched.assignAll(results);
        break;
      case ListType.RecipeResultMissingOne:
        listRecipesResultMissingOne.assignAll(results);
        break;
      case ListType.RecipeUser:
        listRecipesUser.assignAll(results);
        break;
    }
  }

  filterResults({required ListType listType}) async {
    try {
      switch (listType) {
        case ListType.RecipePage:
          statusRecipesPage.value = StatusRecipe.Loading;
          await Future.delayed(const Duration(milliseconds: 500));
          final results = await FirebaseBaseHelper.filterResults(
            tagValue!,
            listType,
            moreFilters: tupleSelected.value.item1 == "test"
                ? null
                : tupleSelected.value,
          );
          listRecipes.assignAll(results);
          listRecipes.refresh();
          statusRecipesPage.value = StatusRecipe.Finished;
          break;
        case ListType.RecipePageFiltered:
          statusRecipesPage.value = StatusRecipe.Loading;
          await Future.delayed(const Duration(milliseconds: 500));
          final results = await FirebaseBaseHelper.filterResults(
            tagValue!, listType,
            //List<Recipe>.from(listRecipes),
            moreFilters: tupleSelected.value.item1 == "test"
                ? null
                : tupleSelected.value,
          );
          listRecipesFiltered.assignAll(results);
          listRecipesFiltered.refresh();
          statusRecipesPage.value = StatusRecipe.Finished;
          break;
        case ListType.CategoryPage:
          statusRecipesCategory.value = StatusRecipeCategory.Loading;
          await Future.delayed(const Duration(milliseconds: 500));
          final results = await FirebaseBaseHelper.filterResults(
            tagValue!,
            listType,
            moreFilters: tupleSelected.value.item1 == "test"
                ? null
                : tupleSelected.value,
          );
          listRecipesCategory.assignAll(results);
          listRecipesCategory.refresh();
          statusRecipesCategory.value = StatusRecipeCategory.Finished;
          break;
        case ListType.RecipeResultMatched:
          statusRecipesResult.value = StatusRecipeResult.Loading;
          await Future.delayed(const Duration(milliseconds: 500));
          final results = await FirebaseBaseHelper.filterResults(
            tagValue!,
            listType,
            moreFilters: tupleSelected.value.item1 == "test"
                ? null
                : tupleSelected.value,
          );
          listRecipesResultMatched.assignAll(results);
          listRecipesResultMatched.refresh();
          statusRecipesResult.value = StatusRecipeResult.Finished;
          break;
        case ListType.RecipeResultMissingOne:
          statusRecipesResult.value = StatusRecipeResult.Loading;
          await Future.delayed(const Duration(milliseconds: 500));
          final results = await FirebaseBaseHelper.filterResults(
            tagValue!,
            listType,
            moreFilters: tupleSelected.value.item1 == "test"
                ? null
                : tupleSelected.value,
          );
          listRecipesResultMissingOne.assignAll(results);
          listRecipesResultMissingOne.refresh();
          statusRecipesResult.value = StatusRecipeResult.Finished;
          break;
        case ListType.RecipeUser:
          statusRecipesResult.value = StatusRecipeResult.Loading;
          await Future.delayed(const Duration(milliseconds: 500));
          final results = await FirebaseBaseHelper.filterResults(
            tagValue!,
            listType,
            moreFilters: tupleSelected.value.item1 == "test"
                ? null
                : tupleSelected.value,
          );
          listRecipesUser.assignAll(results);
          listRecipesUser.refresh();
          statusRecipesResult.value = StatusRecipeResult.Finished;
          break;
      }
      query = textValue.value;
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

  clearlistFilters() {
    listFilters.assignAll(LocalVariables.filters);
    filterSelected.value = listFilters[0].item1;
    tagValue = listFilters[0];
    listFiltersModal.clear();
    tupleSelected.value = Tuple3.fromList(["test", "test", "test"]);
    //Atualiza na lista de receitas os valores
    if (listRecipes.isNotEmpty) {
      filterResults(listType: ListType.RecipePage);
    }
  }

  clearListCategory() {
    statusRecipesCategory = StatusRecipeCategory.None.obs;
    listRecipesCategory.clear();
  }

  clearListRecipeUser() {
    statusRecipesResult = StatusRecipeResult.None.obs;
    listRecipesUser.clear();
  }

  clearListResult() {
    statusRecipesResult = StatusRecipeResult.None.obs;
    listRecipesResult.clear();
    listRecipesResult.refresh();
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
