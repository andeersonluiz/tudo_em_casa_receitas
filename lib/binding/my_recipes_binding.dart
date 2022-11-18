import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/my_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/profile_controller.dart';

class MyRecipesBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MyRecipeController>(MyRecipeController());
    Get.put<ProfileController>(ProfileController());
  }
}
