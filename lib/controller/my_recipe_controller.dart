import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';

class MyRecipeController extends GetxController {
  UserController userController = Get.find();
  var isDeletingRecipe = false.obs;
  deleteRecipe(Recipe recipe) async {
    isDeletingRecipe.value = true;
    var result = await FirebaseBaseHelper.deleteRecipe(
      recipe,
      userController.currentUser.value,
    );
    isDeletingRecipe.value = false;
    if (result == "") {
      return "";
    } else {
      return result;
    }
  }
}
