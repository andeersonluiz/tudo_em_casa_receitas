import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/my_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_infos_controller.dart';

class MyRecipesBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MyRecipeController>(MyRecipeController());
  }
}
