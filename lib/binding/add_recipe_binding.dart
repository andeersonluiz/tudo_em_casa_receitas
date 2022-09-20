import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';

class AddRecipeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CrudRecipeController>(CrudRecipeController(), permanent: true);
  }
}
