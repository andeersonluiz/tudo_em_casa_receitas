// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/model/user_info_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';

import '../model/user_model.dart';

enum StatusMyRecipes { None, Loading, Error, Finished }

class UserController extends GetxController {
  Rx<UserModel> currentUser = UserModel.empty().obs;
  var indexSelected = 0.obs;
  var myRecipes = [].obs;
  var statusMyRecipes = StatusMyRecipes.None.obs;
  var statusMyFavorites = StatusMyRecipes.None.obs;
  var favoriteRecipes = [].obs;
  var errorsListCategories = [];
  var errorsListIngredients = [];
  var errorsListMeasures = [];
  @override
  void onInit() {
    currentUser.value = LocalVariables.currentUser;

    super.onInit();
  }

  setCurrentUser(UserModel user) {
    currentUser = (user).obs;
    currentUser.refresh();
  }

  updateIndexSelected(int newIndex) {
    indexSelected.value = newIndex;
  }

  resetUser() {
    currentUser.value = UserModel.empty();
  }

  addMyRecipe(Recipe rec) {
    myRecipes.add(rec);
    myRecipes.sort((a, b) {
      int cmp = b.statusRecipe.index.compareTo(a.statusRecipe.index);
      if (cmp != 0) return cmp;
      return b.updatedOn.compareTo(a.updatedOn);
    });
  }

  updateMyRecipe(Recipe rec, String lastId) {
    int index;
    if (lastId == "") {
      index = myRecipes.indexWhere((item) => rec.id == item.id);
    } else {
      index = myRecipes.indexWhere((item) => lastId == item.id);
    }

    myRecipes[index] = rec;
    myRecipes.sort((a, b) {
      int cmp = b.statusRecipe.index.compareTo(a.statusRecipe.index);
      if (cmp != 0) return cmp;
      return b.updatedOn.compareTo(a.updatedOn);
    });
  }

  deleteMyRecipe(Recipe rec) {
    myRecipes.removeWhere((item) => rec.id == item.id);
    myRecipes.sort((a, b) {
      int cmp = b.statusRecipe.index.compareTo(a.statusRecipe.index);
      if (cmp != 0) return cmp;
      return b.updatedOn.compareTo(a.updatedOn);
    });
  }

  getMyRecipes() async {
    statusMyRecipes.value = StatusMyRecipes.Loading;
    try {
      if (Get.isRegistered<IngredientController>()) {
        IngredientController ingredientController = Get.find();
        ingredientController.initData();
      }
      myRecipes
          .assignAll(await FirebaseBaseHelper.getMyRecipes(currentUser.value));
      for (Recipe rec in myRecipes) {
        errorsListCategories
            .addAll(rec.categoriesRevisionError.map((e) => e.id).toList());
        errorsListIngredients.addAll(rec.ingredientsRevisionError
            .map((e) =>
                e.name.toLowerCase().toTitleCase().replaceAll(" ", "") +
                e.plurals.toLowerCase().toTitleCase().replaceAll(" ", ""))
            .toList());
        errorsListMeasures
            .addAll(rec.measuresRevisionError.map((e) => e.id).toList());
      }
      if (Get.isRegistered<CrudRecipeController>()) {
        CrudRecipeController crudRecipeController = Get.find();
        if (crudRecipeController.recipeSelected != null) {
          var oldIndex = crudRecipeController.recipeSelected!.id;
          var index = myRecipes.indexWhere(
              (element) => element == crudRecipeController.recipeSelected!);
          var indexRecipeUser = currentUser.value.recipeList
              .indexWhere((element) => element.id == oldIndex);
          currentUser.value.recipeList[indexRecipeUser].id =
              myRecipes[index].id;
          crudRecipeController.recipeSelected!.id = myRecipes[index].id;
        }
      }
      statusMyRecipes.value = StatusMyRecipes.Finished;
    } catch (e) {
      statusMyRecipes.value = StatusMyRecipes.Error;
    }
  }

  removeFavorite(Recipe recipe) async {
    if (favoriteRecipes.isNotEmpty) {
      favoriteRecipes.removeWhere((element) => element.id == recipe.id);
    }
  }

  isMyRecipe(Recipe recipe) {
    var ids = currentUser.value.recipeList.map((e) => e.id).toList();
    if (ids.contains(recipe.id)) {
      return true;
    } else {
      return false;
    }
  }

  var isLoading = false.obs;
  Rx<UserInfo> userInfo =
      UserInfo(idUser: "", name: "", imageUrl: "", followers: -1).obs;
  getUser(String id) async {
    isLoading.value = true;
    UserModel res = await FirebaseBaseHelper.getUserData(id);
    isLoading.value = false;
    userInfo.value = UserInfo(
        idUser: res.id,
        name: res.name,
        imageUrl: res.image,
        followers: res.followers);
    return res;
  }

  getFavoritesRecipes() async {
    await Preferences.loadFavorites();

    statusMyFavorites.value = StatusMyRecipes.Loading;
    try {
      favoriteRecipes.assignAll(await FirebaseBaseHelper.getFavorites(
          LocalVariables.idsListRecipes, currentUser.value));
      statusMyFavorites.value = StatusMyRecipes.Finished;
    } catch (e) {
      statusMyFavorites.value = StatusMyRecipes.Error;
    }
  }

  wipeMyRecipes() {
    myRecipes.assignAll([]);
    statusMyRecipes.value = StatusMyRecipes.None;
  }

  wipeMyRecipesFavorites() {
    favoriteRecipes.assignAll([]);
    statusMyFavorites.value = StatusMyRecipes.None;
  }
}
