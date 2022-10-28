import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/favorite_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';
import 'package:restart_app/restart_app.dart';

class LoginController extends GetxController {
  var emailValue = "".obs;
  var emailRecoverValue = "".obs;
  var passwordValue = "".obs;
  var errorText = "".obs;
  var infoRecoverText = "".obs;
  var isLoading = false.obs;
  var visiblePassword = true.obs;
  var isLoadingLogOut = false.obs;
  UserController userController = Get.find();
  IngredientController ingredientController = Get.find();
  loginWithGoogle() async {
    clearErrorText();
    isLoading.value = true;
    try {
      dynamic value = await FirebaseBaseHelper.loginWithGoogle();
      if (value is UserModel) {
        await Future.wait([
          Preferences.saveUser(value),
          Preferences.loadFavorites(),
          Preferences.loadIngredientPantry(),
          Preferences.loadIngredientHomePantry(),
        ]);
        FavoriteController favoriteController = Get.find();
        favoriteController.refactorLists();
        await ingredientController.initData();
        userController.setCurrentUser(value);
        isLoading.value = false;
        return true;
      } else {
        errorText.value = value;
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorText.value =
          "Erro na conexão com o banco de dados, verifique novamente mais tarde";
      isLoading.value = false;
      return false;
    }
  }

  updateVisiblePassword(bool newValue) {
    visiblePassword.value = newValue;
  }

  loginWithEmailAndPassword() async {
    clearErrorText();
    isLoading.value = true;
    try {
      var value = await FirebaseBaseHelper.loginWithEmailAndPassword(
          emailValue.value, passwordValue.value);
      if (value is UserModel) {
        await Future.wait([
          Preferences.saveUser(value),
          Preferences.loadFavorites(),
          Preferences.loadIngredientPantry(),
          Preferences.loadIngredientHomePantry(),
        ]);
        FavoriteController favoriteController = Get.find();
        favoriteController.refactorLists();
        await ingredientController.initData();
        userController.setCurrentUser(value);
        isLoading.value = false;
        await ingredientController
            .loadIngredientsRevision(userController.currentUser.value);
        return true;
      } else {
        errorText.value = value;
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      errorText.value =
          "Erro na conexão com o banco de dados, verifique novamente mais tarde";

      return false;
    }
  }

  resetPassword() async {
    clearInfoRecoverText();
    try {
      var value =
          await FirebaseBaseHelper.resetPassword(emailRecoverValue.value);
      infoRecoverText.value = value;
    } catch (e) {
      infoRecoverText.value =
          "Erro com a conexão com o banco de dados, tente novamente mais tarde";
    }
  }

  updateEmailValue(String newText) {
    emailValue.value = newText;
  }

  updateEmailRecoverValue(String newText) {
    emailRecoverValue.value = newText;
  }

  updatePasswordValue(String newText) {
    passwordValue.value = newText;
  }

  clearErrorText() {
    errorText.value = "";
  }

  clearInfoRecoverText() {
    infoRecoverText.value = "";
  }

  wipeData() {
    emailValue = "".obs;
    passwordValue = "".obs;
    errorText = "".obs;
  }

  logOut() async {
    isLoadingLogOut.value = true;
    await FirebaseBaseHelper.logOut();
    ingredientController.removeRevisions();
    userController.resetUser();
    await Future.wait([
      Preferences.removeUser(),
      Preferences.loadFavorites(),
      Preferences.loadIngredientPantry(),
      Preferences.loadIngredientHomePantry(),
    ]);
    FavoriteController favoriteController = Get.find();
    favoriteController.refactorLists();
    print("initDat-1a");
    await ingredientController.initData();
    isLoadingLogOut.value = false;
  }
}
