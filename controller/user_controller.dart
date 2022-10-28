// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/model/user_info_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';

import '../model/user_model.dart';

enum StatusMyRecipes { None, Loading, Error, Finished }

class UserController extends GetxController {
  Rx<UserModel> currentUser = (UserModel(
      id: "",
      idFirestore: "",
      image: "",
      name: "",
      description: "",
      wallpaperImage: "",
      recipeList: [],
      followers: -1,
      following: -1,
      followersList: [],
      followingList: [],
      recipeLikes: [])).obs;
  var indexSelected = 0.obs;
  var myRecipes = [].obs;
  var statusMyRecipes = StatusMyRecipes.None.obs;
  var statusMyFavorites = StatusMyRecipes.None.obs;
  var favoriteRecipes = [].obs;
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
    myRecipes
        .sort((a, b) => b.statusRecipe.index.compareTo(a.statusRecipe.index));
  }

  updateMyRecipe(Recipe rec) {
    int index = myRecipes.indexWhere((item) => rec.id == item.id);
    myRecipes[index] = rec;
    myRecipes
        .sort((a, b) => b.statusRecipe.index.compareTo(a.statusRecipe.index));
  }

  deleteMyRecipe(Recipe rec) {
    myRecipes.removeWhere((item) => rec.id == item.id);
    myRecipes
        .sort((a, b) => b.statusRecipe.index.compareTo(a.statusRecipe.index));
  }

  getMyRecipes() async {
    statusMyRecipes.value = StatusMyRecipes.Loading;
    try {
      myRecipes
          .assignAll(await FirebaseBaseHelper.getMyRecipes(currentUser.value));
      statusMyRecipes.value = StatusMyRecipes.Finished;
    } catch (e) {
      print("Erro inesperado. Tente novamente mais tarde(1009)");
      print(e);
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
    print("getUser...");
    print("loading...");
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
      print(e);
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
