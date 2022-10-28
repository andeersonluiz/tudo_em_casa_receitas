import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';

import '../controller/suggestion_controller.dart';

class AddRecipeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CrudRecipeController>(CrudRecipeController());
    Get.put<SuggestionController>(SuggestionController());
  }
}
