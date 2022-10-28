import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';

class MyRecipeController extends GetxController {
  UserController userController = Get.find();

  deleteRecipe(Recipe recipe) async {
    var result = await FirebaseBaseHelper.deleteRecipe(
      recipe,
      userController.currentUser.value,
    );
    if (result == "") {
      return "";
    } else {
      return result;
    }
  }
}
