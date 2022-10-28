// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/model/user_info_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';

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
      recipeLikes: [],
      categoriesRevision: [],
      ingredientsRevision: [],
      measuresRevision: [])).obs;
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
  }

  updateMyRecipe(Recipe rec) {
    int index = myRecipes.indexWhere((item) => rec.id == item.id);
    myRecipes[index] = rec;
  }

  deleteMyRecipe(Recipe rec) {
    myRecipes.removeWhere((item) => rec.id == item.id);
  }

  getMyRecipes() async {
    statusMyRecipes.value = StatusMyRecipes.Loading;
    try {
      myRecipes
          .assignAll(await FirebaseBaseHelper.getMyRecipes(currentUser.value));
      statusMyRecipes.value = StatusMyRecipes.Finished;
    } catch (e) {
      print(e);
      statusMyRecipes.value = StatusMyRecipes.Error;
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

  wipeMyRecipes() {
    myRecipes.assignAll([]);
    statusMyRecipes.value = StatusMyRecipes.None;
  }
}
