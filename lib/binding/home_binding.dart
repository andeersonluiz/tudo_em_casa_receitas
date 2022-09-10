import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/custom_animation_controller.dart';
import 'package:tudo_em_casa_receitas/controller/favorite_controller.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FavoriteController>(FavoriteController());
    Get.put<HomeViewController>(HomeViewController());
    Get.put<CustomAnimationController>(CustomAnimationController());
    Get.put<RecipeResultController>(RecipeResultController());

    Get.lazyPut<IngredientController>(() => IngredientController());
  }
}
