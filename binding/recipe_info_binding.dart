import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/favorite_controller.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/like_controller.dart';
import 'package:tudo_em_casa_receitas/controller/login_controller.dart';
import 'package:tudo_em_casa_receitas/controller/notification_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_infos_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/controller/custom_animation_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';

class RecipeInfoBinding implements Bindings {
  @override
  void dependencies() {
    print("BINDINGGGG");
    var value = Get.isRegistered<UserController>();
    print(value);
    if (!value) {
      Get.put<UserController>(UserController(), permanent: true);
      Get.put<LikeController>(LikeController(), permanent: true);

      Get.put<FavoriteController>(FavoriteController(), permanent: true);
      Get.put<HomeViewController>(HomeViewController(), permanent: true);
      Get.put<CustomAnimationController>(CustomAnimationController(),
          permanent: true);
      Get.put<RecipeResultController>(RecipeResultController(),
          permanent: true);
      Get.lazyPut<IngredientController>(() => IngredientController());

      Get.put<LoginController>(LoginController(), permanent: true);
      Get.put<NotificationController>(NotificationController(),
          permanent: true);
    }
    Get.put<RecipeInfosController>(RecipeInfosController());
  }
}
