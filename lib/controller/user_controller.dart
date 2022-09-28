// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';

import '../model/user_model.dart';

enum StatusMyRecipes { None, Loading, Error, Finished }

class UserController extends GetxController {
  Rx<UserModel> currentUser = UserModel(
      id: "",
      image: "",
      name: "",
      wallpaperImage: "",
      recipeList: [],
      followers: -1,
      following: -1,
      categoriesRevision: [],
      ingredientsRevision: [],
      measuresRevision: []).obs;
  var indexSelected = 0.obs;
  var myRecipes = [].obs;
  var statusMyRecipes = StatusMyRecipes.None.obs;
  @override
  void onInit() {
    currentUser.value = LocalVariables.currentUser;

    super.onInit();
  }

  setCurrentUser(UserModel user) {
    currentUser = (user).obs;
  }

  updateIndexSelected(int newIndex) {
    indexSelected.value = newIndex;
  }

  resetUser() {
    currentUser.value = UserModel(
        id: "",
        image: "",
        name: "",
        wallpaperImage: "",
        recipeList: [],
        followers: -1,
        following: -1,
        categoriesRevision: [],
        ingredientsRevision: [],
        measuresRevision: []);
  }

  addMyRecipe(Recipe rec) {
    myRecipes.add(rec);
  }

  updateMyRecipe(Recipe rec) {
    int index = myRecipes.indexWhere((item) => rec.id == item.id);
    myRecipes[index] = rec;
  }

  deleteMyRecipe(Recipe rec) {
    print("deletei");
    myRecipes.removeWhere((item) => rec.id == item.id);
  }

  getMyRecipes() async {
    statusMyRecipes.value = StatusMyRecipes.Loading;
    try {
      myRecipes
          .assignAll(await FirebaseBaseHelper.getMyRecipes(currentUser.value));
      statusMyRecipes.value = StatusMyRecipes.Finished;
    } catch (e) {
      statusMyRecipes.value = StatusMyRecipes.Error;
    }
  }

  wipeMyRecipes() {
    myRecipes.assignAll([]);
    statusMyRecipes.value = StatusMyRecipes.None;
  }
}
