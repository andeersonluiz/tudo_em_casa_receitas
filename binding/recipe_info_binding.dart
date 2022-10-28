import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_infos_controller.dart';

class RecipeInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RecipeInfosController>(RecipeInfosController());
  }
}
