import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/favorite_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';

import '../model/user_model.dart';
import '../support/preferences.dart';

class RegisterController extends GetxController {
  var nameValue = "".obs;
  var emailValue = "".obs;
  var passwordValue = "".obs;
  var confirmPasswordValue = "".obs;
  var errorText = "".obs;
  var isLoading = false.obs;
  IngredientController ingredientController = Get.find();
  UserController userController = Get.find();

  registerWithGoogle() async {
    clearErrorText();
    isLoading.value = true;
    try {
      var value = await FirebaseBaseHelper.registerWithGoogle();
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
      isLoading.value = false;
      errorText.value =
          "Erro na conexão com o banco de dados, verifique novamente mais tarde";
      return false;
    }
  }

  registerWithEmailAndPassword() async {
    clearErrorText();
    isLoading.value = true;
    try {
      var value = await FirebaseBaseHelper.registerWithEmailAndPassword(
          nameValue.value, emailValue.value, passwordValue.value);
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
        UserController userController = Get.find();
        userController.setCurrentUser(value);
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        errorText.value = value;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      errorText.value =
          "Erro na conexão com o banco de dados, verifique novamente mais tarde";
    }
  }

  updateNameValue(String newText) {
    nameValue.value = newText;
  }

  updateEmailValue(String newText) {
    emailValue.value = newText;
  }

  updatePasswordValue(String newText) {
    passwordValue.value = newText;
  }

  updateConfirmPasswordValue(String newText) {
    confirmPasswordValue.value = newText;
  }

  passwordIsEqual() {
    if (passwordValue.value == confirmPasswordValue.value) {
      return true;
    }
    return false;
  }

  clearErrorText() {
    errorText.value = "";
  }
}
