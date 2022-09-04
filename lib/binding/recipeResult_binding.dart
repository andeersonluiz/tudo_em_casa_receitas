// ignore_for_file: file_names
import 'package:get/instance_manager.dart';
import 'package:tudo_em_casa_receitas/controller/button_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipeResult_controller.dart';

class RecipeResultBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RecipeResultController>(RecipeResultController());
    Get.put<ButtonController>(ButtonController());
  }
}
